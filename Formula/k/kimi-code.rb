class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-2.5.0.tgz"
  sha256 "540ff0c3366bafbfb248bba4bebc3ff6321b5bb1d72f1a65b97d49528e74f324"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7461ef7807caafdc1b938ef0f539906cce47f58b74cc1b34c187b8b6c1ccfc97"
    sha256 cellar: :any, arm64_tahoe:       "7461ef7807caafdc1b938ef0f539906cce47f58b74cc1b34c187b8b6c1ccfc97"
    sha256 cellar: :any, arm64_sequoia:     "7461ef7807caafdc1b938ef0f539906cce47f58b74cc1b34c187b8b6c1ccfc97"
    sha256 cellar: :any, arm64_linux:       "1f685a7e53075bfe9c9ff9556e004da60743f64e349c32c6fe9494ce163c4bdb"
    sha256 cellar: :any, x86_64_linux:      "a1f45db2c7c49a4503599951df65ee18890b88e0752a4150ae45315f58acbc45"
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
