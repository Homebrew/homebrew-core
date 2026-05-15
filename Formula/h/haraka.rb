class Haraka < Formula
  desc "Fast, highly extensible, and event driven SMTP server"
  homepage "https://haraka.github.io/"
  url "https://registry.npmjs.org/Haraka/-/Haraka-3.1.5.tgz"
  sha256 "9144dd29f30bfd211d1a35d8a1a14414bd1151f4a11e8db1787b8e4dfe0828ca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "38740db2389d572b0d7e921c5a565c8e48082555e369a5f5a68962c5e2e08fb2"
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
