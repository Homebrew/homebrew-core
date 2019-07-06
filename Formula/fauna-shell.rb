require "language/node"

class FaunaShell < Formula
  desc "Interactive shell for FaunaDB"
  homepage "https://fauna.com/"
  url "https://registry.npmjs.org/fauna-shell/-/fauna-shell-0.9.5.tgz"
  sha256 "d2cc2b766bef57d4fc24564242eac59ee4ff152c908ba6a8d7b7762f8a2fc3b1"

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

    pipe_output("#{bin}/fauna add-endpoint https://db.fauna.com:443", "your_fauna_secret\nfauna_endpoint\n")

    output = shell_output("#{bin}/fauna list-endpoints")
    assert_equal "fauna_endpoint *\n", output
  end
end
