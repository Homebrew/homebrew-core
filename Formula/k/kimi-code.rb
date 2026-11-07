class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-2.5.2.tgz"
  sha256 "e7e3d7b0097cd09080bb67dea0bbc4cbb2291aebcf58b722c52575ce7b953b20"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "33e559716c056b9604a0ac9e1917d965a0f4dc95741acf8b421da8194e88fea3"
    sha256 cellar: :any, arm64_tahoe:       "33e559716c056b9604a0ac9e1917d965a0f4dc95741acf8b421da8194e88fea3"
    sha256 cellar: :any, arm64_sequoia:     "33e559716c056b9604a0ac9e1917d965a0f4dc95741acf8b421da8194e88fea3"
    sha256 cellar: :any, arm64_linux:       "25ef0621e11c08d8f93e2257af0dc8905726b228db41411d432250c5aa005552"
    sha256 cellar: :any, x86_64_linux:      "d5922ac31cddf727d6140c02ea22818c65bd4e904c2b6d4560ce1a0e78ee1d11"
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
