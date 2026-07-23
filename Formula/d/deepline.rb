class Deepline < Formula
  desc "CLI for Deepline data enrichment and durable plays"
  homepage "https://code.deepline.com"
  url "https://registry.npmjs.org/deepline/-/deepline-0.1.266.tgz"
  sha256 "f11e9b78106858b6082eef3f26baedb084e2c37736144c3556d715c789a22961"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  def post_install
    ohai "Deepline setup"
    puts <<~EOS
      Deepline is installed but not authenticated. Run:
        deepline setup

      Setup opens (or prints) a Deepline authorization URL and writes credentials
      only after you explicitly approve access. Homebrew installation never starts
      authentication or installs agent skills automatically.
    EOS
  end

  test do
    assert_match '"status": "ok"', shell_output("#{bin}/deepline health")
  end
end
