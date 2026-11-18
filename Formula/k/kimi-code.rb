class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-2.6.3.tgz"
  sha256 "718492fc74d6dc242ad50e4b3aa3d02997dabfd776085efe0ad2edfc34049991"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6eb085f204c055d6a58b4ca76b4105a4782e45c0edebbffa75f9034aecf037cc"
    sha256 cellar: :any, arm64_tahoe:       "6eb085f204c055d6a58b4ca76b4105a4782e45c0edebbffa75f9034aecf037cc"
    sha256 cellar: :any, arm64_sequoia:     "6eb085f204c055d6a58b4ca76b4105a4782e45c0edebbffa75f9034aecf037cc"
    sha256 cellar: :any, arm64_linux:       "8e86ebc1506fbf1a3d7cf8e893a0c0048475dedbad5648ca0b74e22d089c1ce0"
    sha256 cellar: :any, x86_64_linux:      "cc15fbb5a0b54d60f23020715028f42c356451d2a99de442e293ea36d7c57ccc"
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
