class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-2.5.1.tgz"
  sha256 "71e6d3175a7472088c66e8e25b2ecbecefea15a6a86a9b6e924eeda7d4cad62a"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9f2b02d72d91d66c6eaad94dd1026927101268f7d67e5a57156ddf23ed5bac33"
    sha256 cellar: :any, arm64_tahoe:       "9f2b02d72d91d66c6eaad94dd1026927101268f7d67e5a57156ddf23ed5bac33"
    sha256 cellar: :any, arm64_sequoia:     "9f2b02d72d91d66c6eaad94dd1026927101268f7d67e5a57156ddf23ed5bac33"
    sha256 cellar: :any, arm64_linux:       "432421bec53d2984daae740149e1bfca010f754c29b1fc2385b2316577119ad5"
    sha256 cellar: :any, x86_64_linux:      "57acb8e6d6799af916bd33e7b30fd43de3c308f84ba90c127c434b7dddb5fe59"
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
