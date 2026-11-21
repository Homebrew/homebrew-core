class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-2.7.2.tgz"
  sha256 "cc36a5e213a0647420853c0e0c9c7ea00e7edfa1986185bb84e4169ac6faf114"
  license "MIT"

  bottle do
    manifest_sha256 "fbb7fed0845b4205923a01a566977d6278b000ee94ca8bb51d55232c31da8f9d"
    sha256 cellar: :any, arm64_golden_gate: "4bde41224c53083e0fb66d3b7c9ccbc1b3ac90cd22fdd30fb7069e34551a76d6"
    sha256 cellar: :any, arm64_tahoe:       "4bde41224c53083e0fb66d3b7c9ccbc1b3ac90cd22fdd30fb7069e34551a76d6"
    sha256 cellar: :any, arm64_sequoia:     "4bde41224c53083e0fb66d3b7c9ccbc1b3ac90cd22fdd30fb7069e34551a76d6"
    sha256 cellar: :any, arm64_linux:       "cc9d7162897235d4a251f8f14eab6ec928123cd33665bc78d28fb5bf9ea83147"
    sha256 cellar: :any, x86_64_linux:      "e4944cefce51e84ae5f00bd76f459abbbb98039b26eda226a399b397f5812fc9"
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
