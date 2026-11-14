class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-2.6.2.tgz"
  sha256 "8b63374979591ccc00a9e6ddb722b2ad62290ee78263f47c761c8f69ed2f44d3"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e39140a4cc07ae024cac093ea2f5e8a5f226b66585c10e8218fbfd77c2071cc2"
    sha256 cellar: :any, arm64_tahoe:       "e39140a4cc07ae024cac093ea2f5e8a5f226b66585c10e8218fbfd77c2071cc2"
    sha256 cellar: :any, arm64_sequoia:     "e39140a4cc07ae024cac093ea2f5e8a5f226b66585c10e8218fbfd77c2071cc2"
    sha256 cellar: :any, arm64_linux:       "ea604c1be5b848a0b4c385c24c4660f4c010f417575ae6661b67d429081707d1"
    sha256 cellar: :any, x86_64_linux:      "2fe1cd048e00fd125bc046ca7f7752f0bb8d9971dc3a0de4b396b32c73b9d29f"
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
