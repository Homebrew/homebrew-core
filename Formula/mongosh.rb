require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-0.15.4.tgz"
  sha256 "8f5e84cb159e502ae9db907ed6f5a5fd4f9016f3dd5514c31d29c887f7cca6a7"
  license "Apache-2.0"

  bottle do
    sha256 arm64_big_sur: "c4581dc13f1119572c390bf5142e6264986e02f28a5940d4eb87c8dc1d02ee9b"
    sha256 big_sur:       "1915b016346107a582c9bdd153be8d589757d7290779cb841a27977bdc4444ad"
    sha256 catalina:      "c7fb24e26d594a011d11008cf7545cf947d7dca5db1369fb85d0e3aaad4b9197"
    sha256 mojave:        "ad00547915b51233274ab068229d3b54c98661630edab62eecdf551e0bbc68e8"
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
