class Npq < Formula
  desc "Audit npm packages before you install them"
  homepage "https://github.com/lirantal/npq"
  url "https://registry.npmjs.org/npq/-/npq-3.16.1.tgz"
  sha256 "1eb7550d78c7b11a565a1594d7cf8846091748c6c185607c725b8af7f95617c0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "270b0b9c567125f1f980825ed21e19c64b2e6d4aa1bc8928563bba1b927788f4"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/npq --version")

    output = shell_output("#{bin}/npq install npq --dry-run")
    assert_match "Packages with issues found", output
  end
end
