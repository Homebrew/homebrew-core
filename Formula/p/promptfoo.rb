class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.120.25.tgz"
  sha256 "3170b2be72127a5f24485631ee45ddc4642eaa685edb497d26b0453fbbfaa2aa"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "6cf678e962eb8e0d94060ab7109d7aa63e4e8e70caccedcf0e153ce46edb36b7"
    sha256                               arm64_sequoia: "fe7085de6badd42b934ce70a1112453c74de3e9bca0445b78ee17a860ce27eb3"
    sha256                               arm64_sonoma:  "f0c55c51eac434a8c85326dbc2ff6697972cf4f71683ad0b6c488e9ad0c9c26a"
    sha256                               sonoma:        "bfc9e28a677f30e350f4b356d1c62e5972a76c81c53a7cc199e0d36311943ff9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66dae4ef0d65a3af9fa82004d244fdcfc4ed5a92b3c1952379711021844eae6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6af9db6ce84f69a3711341a0e29a28ff3dad1d00fb1080f1040aec84072b712"
  end

  depends_on "glib"
  depends_on "node"
  depends_on "vips"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version < 1700
    depends_on "gettext"
    depends_on "pcre2"
  end

  fails_with :clang do
    build 1699
    cause "better-sqlite3 fails to build"
  end

  # Resources needed to build sharp from source to avoid bundled vips
  # https://sharp.pixelplumbing.com/install/#building-from-source
  resource "node-addon-api" do
    url "https://registry.npmjs.org/node-addon-api/-/node-addon-api-8.5.0.tgz"
    sha256 "d12f07c8162283b6213551855f1da8dac162331374629830b5e640f130f07910"
  end

  resource "node-gyp" do
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-12.2.0.tgz"
    sha256 "8689bbeb45a3219dfeb5b05a08d000d3b2492e12db02d46c81af0bee5c085fec"
  end

  def install
    ENV["SHARP_FORCE_GLOBAL_LIBVIPS"] = "1"
    system "npm", "install", *std_npm_args(ignore_scripts: false), *resources.map(&:cached_download)
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    node_modules = libexec/"lib/node_modules/promptfoo/node_modules"
    rm_r(node_modules/"@anthropic-ai/claude-agent-sdk/vendor/ripgrep")
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    keep = node_modules.glob("onnxruntime-node/bin/napi-v*/#{OS.kernel_name.downcase}/#{arch}")
    rm_r(node_modules.glob("onnxruntime-node/bin/napi-v*/*/*") - keep)
    if OS.linux? && Hardware::CPU.intel?
      rm(node_modules.glob("onnxruntime-node/bin/napi-v*/*/*/libonnxruntime_providers_{cuda,tensorrt}.so"))
    end

    # Remove unneeded pre-built binaries
    rm_r(node_modules.glob("@img/sharp-*"))
    rm_r(node_modules.glob("sharp/node_modules/@img/sharp-*"))
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_path_exists testpath/"promptfooconfig.yaml"
    assert_match 'description: "My eval"', (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end
