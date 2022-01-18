require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-1.1.9.tgz"
  sha256 "4c3f636e0ff8817a0e540258b90d6bc5615690f4681b0c2d72322bbb71936694"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_monterey: "da98333104a4b983a3fbad99cbacd26bf941a8c019a84b15059f8078054b28c0"
    sha256                               arm64_big_sur:  "bf1dd7d2b57708a03697a1de5ec4096093c8b1bca22451a15a7cdd4f1bee2f20"
    sha256                               monterey:       "7b8220e90d9a1bff115ffbb2c3984a7825ea78628a6b86fd89f8e00ddbec2cd9"
    sha256                               big_sur:        "784f574873b90abbd1c2f23eb53c5e4e017fa14d45fa57727a3c27ea1f54590d"
    sha256                               catalina:       "f67643eef3a0634bc9313f84527fadd61093c575dd82d0817187c66efe52a816"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99ab798768f2c22dfe24c5c00d0e456e7413390dd14d1a4271be65cfcb3fd819"
  end

  depends_on "node@14"

  def install
    system "#{Formula["node@14"].bin}/npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"mongosh").write_env_script libexec/"bin/mongosh", PATH: "#{Formula["node@14"].opt_bin}:$PATH"
  end

  test do
    assert_match "ECONNREFUSED 0.0.0.0:1", shell_output("#{bin}/mongosh \"mongodb://0.0.0.0:1\" 2>&1", 1)
    assert_match "#ok#", shell_output("#{bin}/mongosh --nodb --eval \"print('#ok#')\"")
  end
end
