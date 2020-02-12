require "language/node"

class FaunaShell < Formula
  desc "Interactive shell for FaunaDB"
  homepage "https://fauna.com/"
  url "https://registry.npmjs.org/fauna-shell/-/fauna-shell-0.11.0.tgz"
  sha256 "4f0c9834fc38b68b11ba045ea96a449de20cf026d9de5a8c7259160b708455e4"

  bottle do
    cellar :any_skip_relocation
    sha256 "12f82c3c0a1d7c0f86300fe9dcbdbe36681cc48f99b3fe8220296862b5962d57" => :catalina
    sha256 "75fee11abe76543cc547bd9268d0d2f72c331a013daca4a0e5eefbce091b012f" => :mojave
    sha256 "7e24cbcdafe28790bb3afe2f26742afece6b598a9dc95ecb09082cb673e5d87c" => :high_sierra
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
