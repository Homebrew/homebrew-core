require "language/node"

class FaunaShell < Formula
  desc "Interactive shell for FaunaDB"
  homepage "https://fauna.com/"
  url "https://registry.npmjs.org/fauna-shell/-/fauna-shell-0.11.4.tgz"
  sha256 "9593dba01597c7e8f84b36c79a2b99305a7e8777aa63b575e0e873860033b33f"

  bottle do
    cellar :any_skip_relocation
    sha256 "d622578625f916d3ef57527a74f076436603bdc48633787099f1da8d4518cc11" => :catalina
    sha256 "7cb2f10d10d81593c681732cf3a0e2154aa7e5858a08b173a419eb1236c47dfa" => :mojave
    sha256 "88a54ce9e512df176d93e3fb412dd7a791567993319bc77c238855694287217c" => :high_sierra
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
