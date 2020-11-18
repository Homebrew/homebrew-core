require "language/node"

class FaunaShell < Formula
  desc "Interactive shell for FaunaDB"
  homepage "https://fauna.com/"
  url "https://registry.npmjs.org/fauna-shell/-/fauna-shell-0.12.1.tgz"
  sha256 "39c0b0ab000775377249811cbd88b5d2c0a9d4a5e921b90fce8c20511c2dcc07"
  license "MPL-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "4c7607199d5156b264d625238f391c1ce7bfd9874badce42940864f4b1daf969" => :big_sur
    sha256 "71b0ffd6ed4bd6f210cc77b29c28d705c7f5dc06fbc6035393b5668ab0c8a52b" => :catalina
    sha256 "7ecc77d5f7984c43fd87b158f578df742ec1fb170de6b372e48f375471d3f339" => :mojave
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/fauna list-endpoints 2>&1", 1)
    assert_match "No endpoints defined", output

    pipe_output("#{bin}/fauna add-endpoint https://db.fauna.com:443", "your_fauna_secret\nfauna_endpoint\n")

    output = shell_output("#{bin}/fauna list-endpoints")
    assert_equal "fauna_endpoint *\n", output
  end
end
