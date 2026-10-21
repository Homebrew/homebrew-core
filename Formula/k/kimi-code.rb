class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-2.2.0.tgz"
  sha256 "b7c21c0e4d17b480be9f2c890f14d769244003bf35c80d67f8139d74f5e4d960"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "97143c5edd6fcc3c84d360402e2b44355a560a992f1092d8a4ef9b12e2a29866"
    sha256 cellar: :any, arm64_tahoe:       "97143c5edd6fcc3c84d360402e2b44355a560a992f1092d8a4ef9b12e2a29866"
    sha256 cellar: :any, arm64_sequoia:     "97143c5edd6fcc3c84d360402e2b44355a560a992f1092d8a4ef9b12e2a29866"
    sha256 cellar: :any, arm64_linux:       "8fd52bf6f5a9b5420fbf0cc8639fc819e264bdd3828c01f8918683636ccb8f94"
    sha256 cellar: :any, x86_64_linux:      "4adffe3b76751d3d6b17d245a2cba4f101c5a1a6902c0100ad44f59f25e53a71"
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
