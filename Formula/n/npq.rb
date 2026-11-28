class Npq < Formula
  desc "Audit npm packages before you install them"
  homepage "https://github.com/lirantal/npq"
  url "https://registry.npmjs.org/npq/-/npq-3.27.7.tgz"
  sha256 "15712108be985a20a94888dd8952552fb26e47f8e87ae711c05d8eefd516e457"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "75ce449d4c088c9c6516622532e342494880aa006223d54e9236ff49f0fa0608"
    sha256 cellar: :any_skip_relocation, all: "6443b36d60049dd1959ed44617e2ce65a077470d50533c64a566c1eac421da0e"
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
