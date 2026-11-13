class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-2.6.0.tgz"
  sha256 "5518c70f364245def14439a1aabd412ea4a927cd76af73f5f3cafd2dcf4257ab"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8e7baf46e4748faa91930bed61c5d83c33aa716731a42cfbcec04d1b0027a274"
    sha256 cellar: :any, arm64_tahoe:       "8e7baf46e4748faa91930bed61c5d83c33aa716731a42cfbcec04d1b0027a274"
    sha256 cellar: :any, arm64_sequoia:     "8e7baf46e4748faa91930bed61c5d83c33aa716731a42cfbcec04d1b0027a274"
    sha256 cellar: :any, arm64_linux:       "ba4ea6beb050f51799985f25f553d9d440a795762588ae1930ec04c4077483a0"
    sha256 cellar: :any, x86_64_linux:      "458ca55ab276af2283042b36beee0e4ca1f0530c7c5254e2ff19491ff1e934f3"
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
