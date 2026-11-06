class Haraka < Formula
  desc "Fast, highly extensible, and event driven SMTP server"
  homepage "https://haraka.github.io/"
  url "https://registry.npmjs.org/Haraka/-/Haraka-3.4.0.tgz"
  sha256 "8213ffc65e79eec76516a4083772fe4da83ee3d3eb72268dc445e1b49db60d12"
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
