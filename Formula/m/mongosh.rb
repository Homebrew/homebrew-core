require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-2.2.2.tgz"
  sha256 "b194b3993bfe13f0a89c47e62b522c8726f1784dc2e9e21c97fc461b3b39ba37"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_sonoma:   "5a7b61e8291f34331f406be524bfe3ea7c8cc0780d49787cf5afa2856df23957"
    sha256                               arm64_ventura:  "af1f3e1cf8d8c8b20fe8560c2322f31b4f0e58480648a025d57349ee692c209f"
    sha256                               arm64_monterey: "d9231abb1046a1e6fa7d26b78baf86661aafd1d3d212f2a17b14b6fd64bd792c"
    sha256                               sonoma:         "f6c0c16035d8d3e8c160e36d9261e4a713bb2271aa4ed62c5f27c60be1bf23c5"
    sha256                               ventura:        "da068cec7b4a1eccf36eeeab4415c669e5b6095bda3aaabcd68b7febd4bac707"
    sha256                               monterey:       "ffc82f10b748599dcf175d0f1e22da519eafbc3e6d4ed897f606d3284df66bfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b46ef1a2fed1118eb28e3a6432fe19054f93aa69c3aa96fec9f4f33a05400d37"
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
