class Npq < Formula
  desc "Audit npm packages before you install them"
  homepage "https://github.com/lirantal/npq"
  url "https://registry.npmjs.org/npq/-/npq-3.27.2.tgz"
  sha256 "9a4d6922d86d8d90f1a7e318ebea8d785e801ad5c984267651712d387f59b102"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4c5c67c8f17240f97e3b25ac6c606d7c0f9cc4e54e3e2e3ddf621c534c40d53c"
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
