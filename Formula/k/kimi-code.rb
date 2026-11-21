class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-2.7.1.tgz"
  sha256 "94231313b593b7a1b8a705bbb6b34768467100f0217ab22ff627f4de2789e269"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ef80a147730b89708c7d709e07e88512943b94df7b8f64d368a4d594db42b46a"
    sha256 cellar: :any, arm64_tahoe:       "ef80a147730b89708c7d709e07e88512943b94df7b8f64d368a4d594db42b46a"
    sha256 cellar: :any, arm64_sequoia:     "ef80a147730b89708c7d709e07e88512943b94df7b8f64d368a4d594db42b46a"
    sha256 cellar: :any, arm64_linux:       "f1f03c07fe25ae75896b5e104dd7ad14ecb097bdab723d0d4a987ed83b2bd5ec"
    sha256 cellar: :any, x86_64_linux:      "00c8cdaf06f6c0f6f08eff05f14b1ad7bcc6d602e774ea19c1daf102274d3bd2"
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
