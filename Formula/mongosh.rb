require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-1.5.3.tgz"
  sha256 "529886214e7bb67cbed7f79f931fa2108f67b780dc4ae2af64f052a4cc53aded"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_monterey: "6f299d338169d423558b33fd467d7ae45610b3a055113f7ebe52f2bd2f339335"
    sha256                               arm64_big_sur:  "ad51faed9fa5ce25c1bd6f6a158435bc56f05427274c43035e271934295cfcab"
    sha256                               monterey:       "1614a215956983d8e73ac7719706e8a6cad48e7a23c88c5fa6f991ad9f5eeea7"
    sha256                               big_sur:        "e6bf29af9faa891b7d796384dfc06e4e5f9834a885476e345c80da31fa87b049"
    sha256                               catalina:       "e4202da0e5fbb112ebbf19f89480d93a0ec037e679e3f5e59915d2d5c673287e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6bd07846acd02f426e0f38f56779b80d5dff38c9ef8da29ac25b5aae8eef5bd3"
  end

  depends_on "node@16"

  def install
    system "#{Formula["node@16"].bin}/npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"mongosh").write_env_script libexec/"bin/mongosh", PATH: "#{Formula["node@16"].opt_bin}:$PATH"
  end

  test do
    assert_match "ECONNREFUSED 0.0.0.0:1", shell_output("#{bin}/mongosh \"mongodb://0.0.0.0:1\" 2>&1", 1)
    assert_match "#ok#", shell_output("#{bin}/mongosh --nodb --eval \"print('#ok#')\"")
  end
end
