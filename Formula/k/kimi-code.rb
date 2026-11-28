class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-2.8.1.tgz"
  sha256 "7e33abab6740bd0eeea9acc04fc050925be0406173683017f41332c1b5a0f10a"
  license "MIT"

  bottle do
    manifest_sha256 "56a57eac87fcdaf65974af72b2222674bb5ddd687cfcb9de2d3badf8b9142a15"
    sha256 cellar: :any, arm64_golden_gate: "5061ddc22b2b698e091a857b8bdf7499054686850abb2d1ee36d35d4c4c1b95b"
    sha256 cellar: :any, arm64_tahoe:       "5061ddc22b2b698e091a857b8bdf7499054686850abb2d1ee36d35d4c4c1b95b"
    sha256 cellar: :any, arm64_sequoia:     "5061ddc22b2b698e091a857b8bdf7499054686850abb2d1ee36d35d4c4c1b95b"
    sha256 cellar: :any, arm64_linux:       "f64fb5e235a606122fea1030e6db82e3e5cd157869d7b8693d74e3d739ad8f01"
    sha256 cellar: :any, x86_64_linux:      "6758b1b235c02bd4299ee557d6f9a93d03752aa30834e2b402f46eff7e1e5b03"
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
