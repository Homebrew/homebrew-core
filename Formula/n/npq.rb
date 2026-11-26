class Npq < Formula
  desc "Audit npm packages before you install them"
  homepage "https://github.com/lirantal/npq"
  url "https://registry.npmjs.org/npq/-/npq-3.27.5.tgz"
  sha256 "609289d02d5ecf4ba57e1e453c0cc12918b91dfd9cd089a72bd655bfa41ac42d"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "cad5e2f27b3cab9eabb9fad3b270bad664411f9b6f655421b6d4e02e4b36de55"
    sha256 cellar: :any_skip_relocation, all: "fc3fae0c18377997d374faa0c3e1fc83ffe3d5890380e1abab13c0edd0c56e79"
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
