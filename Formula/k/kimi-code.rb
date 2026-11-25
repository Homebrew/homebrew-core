class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-2.7.3.tgz"
  sha256 "e634c9d67f29406c24bd90fc406a56c9b2001df390d7c5fb5dff1c78a696c354"
  license "MIT"

  bottle do
    manifest_sha256 "9162ce347df48ea9e67696cbd1243db923f625ccdcef869258ecf2741fe8bc44"
    sha256 cellar: :any, arm64_golden_gate: "4cdb40bf67589937fa4ad68eb2875b7d72a6abd212c56ef2507ec9d949d91303"
    sha256 cellar: :any, arm64_tahoe:       "4cdb40bf67589937fa4ad68eb2875b7d72a6abd212c56ef2507ec9d949d91303"
    sha256 cellar: :any, arm64_sequoia:     "4cdb40bf67589937fa4ad68eb2875b7d72a6abd212c56ef2507ec9d949d91303"
    sha256 cellar: :any, arm64_linux:       "09b0a4d8205b60f91d3a0195910b19ff6a9d58f574bc381613fc9454d49baba1"
    sha256 cellar: :any, x86_64_linux:      "7e584b73738c95dd31b06a03cf97a80405110dda48213c967c92d93f254bafa6"
  end

  depends_on "node"

  on_linux do
    depends_on "patchelf" => :build
    depends_on "libxcb"
  end

  allow_network_access! :build

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir[libexec/"bin/*"]

    kimi_code_prefix = libexec/"lib/node_modules/@moonshot-ai/kimi-code"
    node_modules = kimi_code_prefix/"node_modules"

    # Remove non-native architecture binaries from `native`
    other_arch = Hardware::CPU.arm? ? "x64" : "arm64"
    os = OS.kernel_name.downcase
    rm_r kimi_code_prefix/"native/#{os}/prebuilds/#{os}-#{other_arch}"

    if OS.mac?
      # Strip universal binary to native architecture for `clipboard`
      deuniversalize_machos "#{node_modules}/@mariozechner/clipboard-darwin-universal/clipboard.darwin-universal.node"
    else
      # Help the bundled native module find Homebrew's libxcb.
      Dir[kimi_code_prefix/"native/linux/prebuilds/*/*.node"].each do |native_module|
        system "patchelf", "--set-rpath", formula_opt_lib("libxcb"), native_module
      end
    end
  end

  test do
    # Chokidar's `fs.watch` crashes without FSEvents access in the macOS sandbox
    ENV["CHOKIDAR_USEPOLLING"] = "1" if OS.mac?

    assert_match version.to_s, shell_output("#{bin}/kimi --version")
    assert_match "No providers configured", shell_output("#{bin}/kimi provider list")
    assert_match "No model configured", shell_output("#{bin}/kimi --prompt hello 2>&1", 1)
  end
end
