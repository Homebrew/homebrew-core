class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-2.7.2.tgz"
  sha256 "cc36a5e213a0647420853c0e0c9c7ea00e7edfa1986185bb84e4169ac6faf114"
  license "MIT"

  bottle do
    manifest_sha256 "782075202d55c4a1abb3564d3be3e2b8a58f2dea4602acc2f3f7fab6a515743e"
    sha256 cellar: :any, arm64_golden_gate: "dfffaae9e019869d1e8ca39bab30116aa237dc728db57d48ae9d30c888abf64d"
    sha256 cellar: :any, arm64_tahoe:       "dfffaae9e019869d1e8ca39bab30116aa237dc728db57d48ae9d30c888abf64d"
    sha256 cellar: :any, arm64_sequoia:     "dfffaae9e019869d1e8ca39bab30116aa237dc728db57d48ae9d30c888abf64d"
    sha256 cellar: :any, arm64_linux:       "544d04a559f368b1703fd81d98e1142ef43c57f8325f1bade87560e6a8855d80"
    sha256 cellar: :any, x86_64_linux:      "9b3b52c6c1f530920169a0a8e189a1f29d3f95dc711cb2e71d0929f286e62cba"
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
