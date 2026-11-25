class Haraka < Formula
  desc "Fast, highly extensible, and event driven SMTP server"
  homepage "https://haraka.github.io/"
  url "https://registry.npmjs.org/Haraka/-/Haraka-3.4.2.tgz"
  sha256 "28f20c283dc21f109c9b317199e0405915a67435bcfcacbb7af3d0d84149ca03"
  license "MIT"

  bottle do
    manifest_sha256 "4d992f9366ce7fc546cab54bf692b34e0e65ef1c81c3576c2b3fcc1647dc684a"
    sha256 cellar: :any_skip_relocation, all: "73e9f301f0ed3a4ebd6cc594f5aecc9148f0b6e3142e9802b24c955951d55669"
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
