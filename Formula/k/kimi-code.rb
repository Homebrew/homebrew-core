class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-2.4.1.tgz"
  sha256 "e7dac04fa7a155c506d86099584fe442f97a222e44da2c042749968dfcae8e09"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a085e30dfd62a176d3bfeff8049d493533a5814629d269c5fefa772cd8cd47af"
    sha256 cellar: :any, arm64_tahoe:       "a085e30dfd62a176d3bfeff8049d493533a5814629d269c5fefa772cd8cd47af"
    sha256 cellar: :any, arm64_sequoia:     "a085e30dfd62a176d3bfeff8049d493533a5814629d269c5fefa772cd8cd47af"
    sha256 cellar: :any, arm64_linux:       "a5e258beeaebb82d73ba59d510726f94551d22632c3e789733be47c9b7170677"
    sha256 cellar: :any, x86_64_linux:      "9cdbc5a3171e60cba872d60d7aeacd7852835ce38337cef400780b89bc998e7e"
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
