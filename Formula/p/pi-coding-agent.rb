class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@mariozechner/pi-coding-agent/-/pi-coding-agent-0.65.2.tgz"
  sha256 "5d628942f954fddb65105aa1bf2b36a7af15df3a69fe8a89f98071f8a7ca9f2f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8f95162138691642f04677f07e32a2f7ee381b7b89c28a44cb0f26d1abe335b0"
    sha256 cellar: :any,                 arm64_sequoia: "72cc782bcd80e320614ef50523a51c22484f093fd09a0fa8d66007a8748f4b8f"
    sha256 cellar: :any,                 arm64_sonoma:  "72cc782bcd80e320614ef50523a51c22484f093fd09a0fa8d66007a8748f4b8f"
    sha256 cellar: :any,                 sonoma:        "4a2a1534f46a9922bfb34347993f67fbb6c7c6e8dbe54efbcd0d6e0db0b876a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0712b537a5190c53567df62e71093b2268d56340bdc3e928cade0d4cc528338c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80bc6adb7eeed797f4b0c3c270b11e7701e73775e05122da10f3ddd6eb6357b7"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@mariozechner/pi-coding-agent/node_modules/"
    deuniversalize_machos node_modules/"@mariozechner/clipboard-darwin-universal/clipboard.darwin-universal.node"

    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os = OS.linux? ? "linux" : "darwin"
    node_modules.glob("koffi/build/koffi/*").each do |dir|
      basename = dir.basename.to_s
      rm_r(dir) if basename != "#{os}_#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pi --version 2>&1")

    ENV["GEMINI_API_KEY"] = "invalid_key"
    output = shell_output("#{bin}/pi -p 'foobar' 2>&1", 1)
    assert_match "API key not valid", output
  end
end
