class Npq < Formula
  desc "Audit npm packages before you install them"
  homepage "https://github.com/lirantal/npq"
  url "https://registry.npmjs.org/npq/-/npq-3.27.4.tgz"
  sha256 "e191ff8ac89816ccffd688d80d37f91028821055435db704a4a9676192261b55"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0aed395ee6cf6e851d745e4aa2356315901a6a465ba89de86541b009496d7417"
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
