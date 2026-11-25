class Haraka < Formula
  desc "Fast, highly extensible, and event driven SMTP server"
  homepage "https://haraka.github.io/"
  url "https://registry.npmjs.org/Haraka/-/Haraka-3.4.2.tgz"
  sha256 "28f20c283dc21f109c9b317199e0405915a67435bcfcacbb7af3d0d84149ca03"
  license "MIT"

  bottle do
    manifest_sha256 "c630705d600ca0a5a94d64c555cd8e35e1c9151f0604b755db31018115930aa7"
    sha256 cellar: :any_skip_relocation, all: "85ab392d80d09ff4e5d734f786c3dffd56ef8fe3876242bd43addaf33260127e"
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
