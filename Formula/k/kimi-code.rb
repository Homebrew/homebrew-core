class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-2.0.2.tgz"
  sha256 "432cd0b0ed4184d01c29c5ef21a88303b81d3539f3a771ec64af6cbfa4aa8a77"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b46d25be3f400127d87c98b686136a7ff4218d0ca7add8c270d9df94041afdb0"
    sha256 cellar: :any, arm64_tahoe:       "b46d25be3f400127d87c98b686136a7ff4218d0ca7add8c270d9df94041afdb0"
    sha256 cellar: :any, arm64_sequoia:     "b46d25be3f400127d87c98b686136a7ff4218d0ca7add8c270d9df94041afdb0"
    sha256 cellar: :any, arm64_linux:       "41720c93e7416f93fea00e35699a4f11575cbfa512c0e02f567eae1fd4a45e57"
    sha256 cellar: :any, x86_64_linux:      "d6811b5f0ea8ef3586da0fe688698b07fb1fa79fca17ef86ce4fcafa0d3cfcdc"
  end

  depends_on "node"

  on_linux do
    depends_on "patchelf" => :build
    depends_on "libxcb"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir[libexec/"bin/*"]

    kimi_code_prefix = libexec/"lib/node_modules/@moonshot-ai/kimi-code"
    node_modules = kimi_code_prefix/"node_modules"

    # Remove non-native architecture binaries from `native` and `node-pty`
    other_arch = Hardware::CPU.arm? ? "x64" : "arm64"
    os = OS.kernel_name.downcase
    rm_r kimi_code_prefix/"native/#{os}/prebuilds/#{os}-#{other_arch}"

    if OS.mac?
      rm_r node_modules/"node-pty/prebuilds/darwin-#{other_arch}"

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
