class Haraka < Formula
  desc "Fast, highly extensible, and event driven SMTP server"
  homepage "https://haraka.github.io/"
  url "https://registry.npmjs.org/Haraka/-/Haraka-3.3.2.tgz"
  sha256 "dac4a96f8eb57fa3a0a6c74df38c0bf71ccd730147d210597a75ded20e19e02a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "45172dd32e7e4c955e1a7479459c8dd489b3141a66ea32fc8a479e0b47f450ae"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/haraka --version")

    system bin/"haraka", "--install", testpath/"config"
    assert_path_exists testpath/"config/README"

    output = shell_output("#{bin}/haraka --list")
    assert_match "plugins/auth", output
  end
end
