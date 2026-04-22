class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@mariozechner/pi-coding-agent/-/pi-coding-agent-0.68.0.tgz"
  sha256 "5856e29ef7ad794271fb466d033ec1442e1613690a9767416fbd322524321b25"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "536a73ae0565b307d5b58b70404ad342a1e64748cbc850b23bed631617ca0eac"
    sha256 cellar: :any,                 arm64_sequoia: "cf0ae45f3dcba243aa60680b4fd864ad222b39506e80864a35b5d6f79f4b73cd"
    sha256 cellar: :any,                 arm64_sonoma:  "cf0ae45f3dcba243aa60680b4fd864ad222b39506e80864a35b5d6f79f4b73cd"
    sha256 cellar: :any,                 sonoma:        "1ea6591bf1d65354fdb51881276e185db9616b06f042053563e9726429fd4f97"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a68b877e371b3c58b7d941519c0fcb7ff5910771b79bf6338288b4ce2748f948"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af599110bede000d50302ef4b0c009eed2398c36b496f9e7aac2638b03bc7103"
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
