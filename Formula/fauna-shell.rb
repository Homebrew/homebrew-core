require "language/node"

class FaunaShell < Formula
  desc "Interactive shell for FaunaDB"
  homepage "https://fauna.com/"
  url "https://registry.npmjs.org/fauna-shell/-/fauna-shell-0.9.2.tgz"
  sha256 "3fa3e83fab7bc1625b38616b8254a313216b41815bcdaeaabb21b485d8144f0d"

  bottle do
    cellar :any_skip_relocation
    sha256 "da81642eacc2034c72996f88008dbbab1c3ecea1face54455d12437b2cfe2d53" => :mojave
    sha256 "774f313d8c73b5b45c0c2133c0ea73180de28c5ca0b72a5d7f52b765ca0b83d2" => :high_sierra
    sha256 "ee14539b477d19413e96057548e500f3c4409cd4d8bfc8316e72432a70a47ae9" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/fauna list-endpoints 2>&1", 1)
    assert_match "No endpoints defined", output

    pipe_output("#{bin}/fauna add-endpoint https://endpoint1:8443", "secret\nendpoint1\n")

    output = shell_output("#{bin}/fauna list-endpoints")
    assert_equal "endpoint1 *\n", output
  end
end
