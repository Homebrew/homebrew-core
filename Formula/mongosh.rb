require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-0.14.0.tgz"
  sha256 "7b5a140689b4460a8b87008e6b7e7cb19acbc6e6cd1ab713e1a8923f3a995ca8"
  license "Apache-2.0"

  bottle do
    sha256 arm64_big_sur: "5b4377a3429a66afcb34f8a14119112c045f86889c8a667f656282c2044c7ac1"
    sha256 big_sur:       "b0b2c5bf6df51288ffc542c91394880689e7aa36fc5ab97d8b3e08d9d8fe145b"
    sha256 catalina:      "099214e38e1c1ba6007719f3ff956e56b1a8c954280b3e6883bdc472d7677fe0"
    sha256 mojave:        "9c46c746cf8f65a8418cb39237471cd6338135e398f2ace965a6c580e1165951"
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
