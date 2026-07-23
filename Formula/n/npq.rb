class Npq < Formula
  desc "Audit npm packages before you install them"
  homepage "https://github.com/lirantal/npq"
  url "https://registry.npmjs.org/npq/-/npq-3.23.2.tgz"
  sha256 "8d44c8de6618e5329092ba2bbb045ad189e9f9660ddc9646b08ddb23b28623e7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "655994b9278a76cc5678bd7892e43ea324aa625608ef94914a6a88557b15a27f"
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
