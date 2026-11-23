class Haraka < Formula
  desc "Fast, highly extensible, and event driven SMTP server"
  homepage "https://haraka.github.io/"
  url "https://registry.npmjs.org/Haraka/-/Haraka-3.4.1.tgz"
  sha256 "5d7ab30be66dc687d4ab2e6312b0e6e33893656a9d6fadfb28efc5a084113af3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e2f76326499995260a40411d765827d920b2a9a4653699f298ea2a421bb8137b"
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
