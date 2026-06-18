class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.17.0.tgz"
  sha256 "f38460b4f3baa3ab45ece489d2f4825ab468c724d7ed48ad58fadbb3a16d98a6"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e439e0a34701595a465ce7f90b8ca21771a96d4db9115149e9ca03af914f03fa"
    sha256 cellar: :any,                 arm64_sequoia: "98fc6d0df7a086fdd53180404e98dfdd1dc5e3c71adaf2b2ce3fc201665e5369"
    sha256 cellar: :any,                 arm64_sonoma:  "98fc6d0df7a086fdd53180404e98dfdd1dc5e3c71adaf2b2ce3fc201665e5369"
    sha256 cellar: :any,                 sonoma:        "cc46c92b98b67190629c05387e816f75e7107a5131413461d74f287a26c76525"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac66958c96fffa3125de78f914618fbfaf36fcf83e733aba37abfc1860a8f6db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5286db5e4483e8dcc8d67ffe689b3dc5581918ee47530bbbfeb0cc5611a2a791"
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
