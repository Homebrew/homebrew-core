require "language/node"

class Fx < Formula
  desc "Command-line JSON processing tool"
  homepage "https://github.com/antonmedv/fx"
  url "https://registry.npmjs.org/fx/-/fx-13.0.0.tgz"
  sha256 "a118a1bf477a9e75b66b3769afad1f1c96b78d2683854e5bb07b4777d151d878"

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
