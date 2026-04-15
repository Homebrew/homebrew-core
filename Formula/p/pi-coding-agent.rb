class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@mariozechner/pi-coding-agent/-/pi-coding-agent-0.67.2.tgz"
  sha256 "55d0a7281e090ee79d037ae490995214ea2ea395a586b0933a58fc30ba57a928"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1c74850d58d9f2d089d32597a0a33d679076ff76b2a3419d322fb5cde75163cc"
    sha256 cellar: :any,                 arm64_sequoia: "68a00fccba85758dbbb5c9c3e999d64fc473a7cfe69a29b9cb5803d2e0bde7b0"
    sha256 cellar: :any,                 arm64_sonoma:  "68a00fccba85758dbbb5c9c3e999d64fc473a7cfe69a29b9cb5803d2e0bde7b0"
    sha256 cellar: :any,                 sonoma:        "cfeeda056626afb9efea3a98aef26ec4111bf0e870fff2c145cc75d4305432d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aee9396400321fc896c6c31516a6d18271b6f58b4ea8896c5264a0e7eb9dd8a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfd3245ed18ee24fe7a62b656c7141484b12a7d38783cabdfc8a91bd5cee3a74"
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
