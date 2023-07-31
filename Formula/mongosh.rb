require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-1.10.3.tgz"
  sha256 "824d01bb6eb5ab4c48431512b28d135041b113710065d15994e3acc1d1abe633"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_ventura:  "b1de1b99e62856df66a89b9b75e899cd70184c9c230c9132b1270de5eaa03023"
    sha256                               arm64_monterey: "a01a69a88e6de003a378ee60e0692b2d43974d092b5a199de8f2a6e6a90821e0"
    sha256                               arm64_big_sur:  "62dd9ff5876228e2a386b872aa6ae807c83f28b1c60522c915c5bd3d088363e8"
    sha256                               ventura:        "de1d3427c6b9a17652bd7c7c4e96b00fedbf4594dbeda546da1f82bc7c7bc74e"
    sha256                               monterey:       "78ec8754e8e9cdd4c3c12c9f851cf2e1308eb06dfa08d687e27e090eaed446cf"
    sha256                               big_sur:        "ad8508e26aa8dc4a4f22bf221e832850436fe6ae84e578b825b18d5547fc0307"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "786c0a01aed523265ceca102b240250d94c19b8964ddc58024fc5b4072c2c748"
  end

  depends_on "node@16" # try `node` after https://jira.mongodb.org/browse/MONGOSH-1391

  def install
    system "#{Formula["node@16"].bin}/npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"mongosh").write_env_script libexec/"bin/mongosh", PATH: "#{Formula["node@16"].opt_bin}:$PATH"
  end

  test do
    assert_match "ECONNREFUSED 0.0.0.0:1", shell_output("#{bin}/mongosh \"mongodb://0.0.0.0:1\" 2>&1", 1)
    assert_match "#ok#", shell_output("#{bin}/mongosh --nodb --eval \"print('#ok#')\"")
    assert_match "all tests passed", shell_output("#{bin}/mongosh --smokeTests 2>&1")
  end
end
