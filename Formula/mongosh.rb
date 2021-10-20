require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-1.1.0.tgz"
  sha256 "1ebe806f4b9aa75687caf756c21da1207da829a6a0e28f95f108f467d571b672"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_big_sur: "44af0724aba83db691550ed5c7c4fea17ca089c11aa66b175492b03eff70ae5c"
    sha256                               big_sur:       "9705c160a5583742a9355491a325fecd6dcf54bab2bd1e60a9c8ab49cb7d4f62"
    sha256                               catalina:      "333d662c3361918866c62d972fafe30529e75f1de5f38f06f4bdadbae6d3a6f0"
    sha256                               mojave:        "e381d7d3a5bc08bf62c09fd484bb197244a79c207bee3a70c5b395877257f975"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2aaa1fc7557dbfad4a8847392992e5fcefb48c26fe72b8e38e27819fa74355ad"
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
