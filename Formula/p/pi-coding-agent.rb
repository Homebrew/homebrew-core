class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@mariozechner/pi-coding-agent/-/pi-coding-agent-0.73.0.tgz"
  sha256 "f614d1521f3bb6448e41d296d6af4e7140be7a4c5af38e0eeb9cae69bb1274bb"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b9f485f1421ab406273c6bd22cc2ee3f8f9ed2e760be90b47492e518f2e03e45"
    sha256 cellar: :any,                 arm64_sequoia: "361f8918fd5a16bc65fedf3faff808a2ce55da90fdd7797ce8f25585f2f09a3e"
    sha256 cellar: :any,                 arm64_sonoma:  "361f8918fd5a16bc65fedf3faff808a2ce55da90fdd7797ce8f25585f2f09a3e"
    sha256 cellar: :any,                 sonoma:        "c66eb4aa7be911379b1b76f9be1d3383fef3197a27d7f3498b499b985630a158"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b07ae9428a40de693e7a64f53293d1a1dabc3220732754ece3be816c82a825f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e43b6b34e2d4c5d1bb2be513705deaa21ab091e070db38762020fe4255f4eae7"
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
