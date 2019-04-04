require "language/node"

class Fx < Formula
  desc "Command-line JSON processing tool"
  homepage "https://github.com/antonmedv/fx"
  url "https://registry.npmjs.org/fx/-/fx-14.0.0.tgz"
  sha256 "9029125844cf56dea68e3cbabe6d1e85a53b820ab8b1102496074284ee04f186"

  bottle do
    cellar :any_skip_relocation
    sha256 "f80b0acc33fef4e74f39a2bd4db95f822e2cacea626e5db01c1f31f2535f8c3d" => :mojave
    sha256 "162b67dd39fd397c53a886f3fcdfc67a07f60d52356d738dc983b9c5fc6d1fdb" => :high_sierra
    sha256 "279cdb8edb468946dfada375bc286fccd449bf9b946cbbf1bdced4798a710e35" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "bar", shell_output("echo '{\"foo\": \"bar\"}' #{bin}/fx .foo")
  end
end
