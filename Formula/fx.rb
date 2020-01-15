require "language/node"

class Fx < Formula
  desc "Command-line JSON processing tool"
  homepage "https://github.com/antonmedv/fx"
  url "https://registry.npmjs.org/fx/-/fx-18.0.0.tgz"
  sha256 "b7afc9c8ad0849f62050722f13aab5528197df1689680305e11d9db99aeb9718"

  bottle do
    cellar :any_skip_relocation
    sha256 "4b624c86e3931a52070e2e856752dc3485e8c3c74922c2d12be589f7f53f647b" => :catalina
    sha256 "7eeb803bcc4589c5da22c4036255482817f30dc140ddb17442df09f867755d62" => :mojave
    sha256 "4698de64ffa0c2a77b4fa203fc9b19614b7087e9a3c9238f4024178bc9a54060" => :high_sierra
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
