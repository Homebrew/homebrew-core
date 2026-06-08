class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://github.com/MoonshotAI/kimi-code"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.11.0.tgz"
  sha256 "4b6cbf522cbb4870d56e18e2852e20a6000b22a964bc605fe3448fba9603f489"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "898f79624c921cb7fc272d44e8bf787c1b6343ce0a6c3da7c5537fa11d68d3f5"
    sha256 cellar: :any,                 arm64_sequoia: "5adbb209043654b4043a00b9d482c6f34ed554adbf7411d893199a7e3ba3e59d"
    sha256 cellar: :any,                 arm64_sonoma:  "5adbb209043654b4043a00b9d482c6f34ed554adbf7411d893199a7e3ba3e59d"
    sha256 cellar: :any,                 sonoma:        "25860f2b57b087a65dce5f8c88076819edb6d07a6a44a0946f8b31fe7aedad58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e685c9f755b0cd006cbc2d0dcfc24f5a5542260cb001d0fcbdee77f99e54c02f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c781f4835703b2841c046dd3291c8d57ad0ecdec71b3874246761464ef52d492"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir[libexec/"bin/*"]

    node_modules = libexec/"lib/node_modules/@moonshot-ai/kimi-code/node_modules"

    # Remove non-native architecture binaries from `koffi`
    if OS.mac?
      if Hardware::CPU.arm?
        rm_r node_modules/"koffi/build/koffi/darwin_x64"
      elsif Hardware::CPU.intel?
        rm_r node_modules/"koffi/build/koffi/darwin_arm64"
      end
    elsif OS.linux?
      # koffi requires libc++ which is not available in Homebrew Linux;
      # remove all prebuilt native binaries to avoid audit/linkage failures
      rm_r node_modules/"koffi/build"
    end

    # Strip universal binary to native architecture for `clipboard`
    if OS.mac?
      deuniversalize_machos "#{node_modules}/@mariozechner/clipboard-darwin-universal/clipboard.darwin-universal.node"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kimi --version")
    assert_match "No providers configured", shell_output("#{bin}/kimi provider list")
    assert_match "No model configured", shell_output("#{bin}/kimi --prompt hello 2>&1", 1)
  end
end
