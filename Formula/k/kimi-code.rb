class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-2.5.3.tgz"
  sha256 "7c6a44fb54265f9b0d10c35e32c538678a655598f49eba434780c60077fa6c7a"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "db31e598ebf3cd19208e2a35bb68481f198a1b419da0f1ea1008bca293b8406f"
    sha256 cellar: :any, arm64_tahoe:       "db31e598ebf3cd19208e2a35bb68481f198a1b419da0f1ea1008bca293b8406f"
    sha256 cellar: :any, arm64_sequoia:     "db31e598ebf3cd19208e2a35bb68481f198a1b419da0f1ea1008bca293b8406f"
    sha256 cellar: :any, arm64_linux:       "0413e2d40f539b0dc9c606208389abb10e16c4e5a2703ffb8611cfd6e58730a1"
    sha256 cellar: :any, x86_64_linux:      "de42667c8f2573a36ead7144854cc7972b6821012e54769969ae599c921d5bad"
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
