class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.120.26.tgz"
  sha256 "2835ee7da76c4af2d1c938cbb41f932b1e84a1b838da59e3fd48b504d3b772bd"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "487598999b9055e2f93022865806bb7b2a7c27086185799f203d6c8f9441fe94"
    sha256                               arm64_sequoia: "7a8e10ab79ae058e5e7c49645047b7fe00651b30be41c014f1a5471d534bc817"
    sha256                               arm64_sonoma:  "7876f2fa017a355ececc6f104856cea5eed916668cb9dd7b7aaaabea83cd43b7"
    sha256                               sonoma:        "d6d08e1a9928eecdb30e524de79d42921ed979e7a0c9d65446d5ce2a49a6df96"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94876482947603d227b59aad84fe136c490bac6f5ca627f89e019e21f0aa2df2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80f917ca68cf4192c7d9a2227adc9d44a2a389cf6bf9e2582e4625a87ce8795e"
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
