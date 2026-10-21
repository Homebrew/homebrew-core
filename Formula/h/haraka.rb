class Haraka < Formula
  desc "Fast, highly extensible, and event driven SMTP server"
  homepage "https://haraka.github.io/"
  url "https://registry.npmjs.org/Haraka/-/Haraka-3.3.5.tgz"
  sha256 "cf22799d7426632e6884ae109ca4ea7582f7828bb8366a08105c1e032f46e7a7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9aad0a3dc7847883ab0685a9228daafce9d2a781cfa6b082c440569f6082a783"
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
