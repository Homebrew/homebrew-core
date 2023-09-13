require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-2.0.0.tgz"
  sha256 "202d0b1decd6abdd4c8de25cc2e56ad749f9552a8493a042c9d1175337de2a9c"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_ventura:  "f56a1b96be34f3186ff8971813c8d6b7278efe570b582c937bc0c967a028a4d2"
    sha256                               arm64_monterey: "2259622ed566aabec7488b00e1df5dbc7019857d0bae6a92b820e5369b486883"
    sha256                               arm64_big_sur:  "992f538f528a0513ed1ba3786661d2a78d03fee63ddcec7adedd51268d3a8c9b"
    sha256                               ventura:        "0622a9c9dd8db6345b298522cc36fe84375fb03ace4baf10a1ee3692966ffbdd"
    sha256                               monterey:       "9b4fbfee198070426627c5f68d6f1a958625c2e343edd12fef803bdad3baade3"
    sha256                               big_sur:        "704b7953ce6b795efcaa181fbab6cb40210fa26f08f6a0d3c311308c499ba93c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53dfb070f5caf24120c036495a2caa244b9cff5709ec0f756ce611e722c8348a"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"mongosh").write_env_script libexec/"bin/mongosh", PATH: "#{Formula["node"].opt_bin}:$PATH"
  end

  test do
    assert_match "ECONNREFUSED 0.0.0.0:1", shell_output("#{bin}/mongosh \"mongodb://0.0.0.0:1\" 2>&1", 1)
    assert_match "#ok#", shell_output("#{bin}/mongosh --nodb --eval \"print('#ok#')\"")
    assert_match "all tests passed", shell_output("#{bin}/mongosh --smokeTests 2>&1")
  end
end
