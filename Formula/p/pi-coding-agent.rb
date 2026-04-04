class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@mariozechner/pi-coding-agent/-/pi-coding-agent-0.65.0.tgz"
  sha256 "44490f305af5650cfcdd3b44066a157d5957fb861ab801b6ae4185d50e06fc67"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8e78bd9d4dad7e50c01adb561018edce1761bc4d9bebc1f546d1453d2a886917"
    sha256 cellar: :any,                 arm64_sequoia: "ab5f5aa5796b51a30daa2c68f868c0ca67ed0009d672d18b9eade1da3cc9622f"
    sha256 cellar: :any,                 arm64_sonoma:  "ab5f5aa5796b51a30daa2c68f868c0ca67ed0009d672d18b9eade1da3cc9622f"
    sha256 cellar: :any,                 sonoma:        "159e7f8ea25e2df0a3e31efb58be531ae17e599a2efe04d5c3a6c5a807bd1c0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa21885b34781d12fe4f50eefd1a45afa8bc844e9b8f72185a50f6970f9941cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e9c8c2eb2618e4bd1ca3e82488cd0f37e322a9b30133998f53813e3a3bd01df"
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
