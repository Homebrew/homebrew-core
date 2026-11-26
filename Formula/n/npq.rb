class Npq < Formula
  desc "Audit npm packages before you install them"
  homepage "https://github.com/lirantal/npq"
  url "https://registry.npmjs.org/npq/-/npq-3.27.5.tgz"
  sha256 "609289d02d5ecf4ba57e1e453c0cc12918b91dfd9cd089a72bd655bfa41ac42d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "542f1d619d1ad2b1aebdbdfdb89c189583e32841fadf65c83e8c8dcba49c5cdd"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/npq --version")

    output = shell_output("#{bin}/npq install npq@3.5.3 --dry-run", 1)
    assert_match "Package Health - Detected an old package", output
  end
end
