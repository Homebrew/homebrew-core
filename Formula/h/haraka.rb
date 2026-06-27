class Haraka < Formula
  desc "Fast, highly extensible, and event driven SMTP server"
  homepage "https://haraka.github.io/"
  url "https://registry.npmjs.org/Haraka/-/Haraka-3.3.1.tgz"
  sha256 "166892144098305a12ec1fd1d6d06e077a10c7adf0926e3baca049f24f675e4f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1df750e2e2d8aee32cfcdb0f9326a26c092ce5395639a2c2304f0703525f3e0e"
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
