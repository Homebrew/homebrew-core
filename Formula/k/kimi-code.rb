class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-2.6.2.tgz"
  sha256 "8b63374979591ccc00a9e6ddb722b2ad62290ee78263f47c761c8f69ed2f44d3"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "98b8c55d58caede2f1d9aaef62b20b2134359ddf2c0bb558359aea6b1d46d0c3"
    sha256 cellar: :any, arm64_tahoe:       "98b8c55d58caede2f1d9aaef62b20b2134359ddf2c0bb558359aea6b1d46d0c3"
    sha256 cellar: :any, arm64_sequoia:     "98b8c55d58caede2f1d9aaef62b20b2134359ddf2c0bb558359aea6b1d46d0c3"
    sha256 cellar: :any, arm64_linux:       "dcb8557540ec0f7540df896ced3dd35916a93528e366f645f42207e0b13b8914"
    sha256 cellar: :any, x86_64_linux:      "20e9e07ecd4892814d3f340a35590f3872ff8b2280b17be48d799a3158829f1d"
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
