class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.120.19.tgz"
  sha256 "9f5af22119b3bd032a74c6046efb901b12f325d6462d9538664fb2b21498e053"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "0b016a253f39b1058914e0b727f26349ca6cf635c394efd562248d469ec25f8a"
    sha256                               arm64_sequoia: "9bb81546314b37b8a4bf7cf92a75e4f8005b0f82a3e6c502415a7d86242409fa"
    sha256                               arm64_sonoma:  "dc57e8dd29216211957d51dbb9575ca2e9263ca6907096f1476d59feae3df652"
    sha256                               sonoma:        "36d4027445482c8f1d5ac3f1e7cb88b61a20ee4f29fb684569e2874ef2f40280"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05902d4a6680f9c1b03143bd57fe06f79541a5e69c832caf919b50a0086b8723"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "010cae127008b0ca1c97abe963faa450e88ca180f8d323eb5ebc1cac46bc8acf"
  end

  depends_on "glib"
  depends_on "node"
  depends_on "vips"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version < 1700
    depends_on "gettext"
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

    os = OS.mac? ? "apple-darwin" : "unknown-linux-musl"
    arch = Hardware::CPU.arm? ? "aarch64" : "x86_64"

    # Remove incompatible pre-built binaries
    node_modules = libexec/"lib/node_modules/promptfoo/node_modules"
    rm_r(node_modules/"@anthropic-ai/claude-agent-sdk/vendor/ripgrep")
    codex_vendor = node_modules/"@openai/codex-sdk/vendor"
    codex_vendor.children.each { |dir| rm_r dir if dir.basename.to_s != "#{arch}-#{os}" }

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
