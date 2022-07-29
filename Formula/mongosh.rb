require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-1.5.3.tgz"
  sha256 "529886214e7bb67cbed7f79f931fa2108f67b780dc4ae2af64f052a4cc53aded"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_monterey: "b86f36b63f7a8fc81a4911cad19c187cbfb0701030b356fc10213176b55ab28a"
    sha256                               arm64_big_sur:  "cb1d3d2f23edc28f26f22c7b78caf247e34e5fca96ca5f1c48206bda428299b0"
    sha256                               monterey:       "4357d41a959d18c306a55fcfcf193e472bc849b3d4ff367df226aecede5d6e3d"
    sha256                               big_sur:        "381b2a0e7f49f92303da64aa6b19b3335aa9d3da631c991048a105ab84e997e5"
    sha256                               catalina:       "e77aa9c6d3562d8eb14e363ab1cdb1156f1e57c0bd2657ad3da8813fdee79aa6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dab62503556dce9ab1ba1cabe03c5c152c5c7fbc232009fa1f9da0247f2ec480"
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
