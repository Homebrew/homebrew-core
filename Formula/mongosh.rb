require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-1.9.1.tgz"
  sha256 "f7cc6072eb17b72fc0cdb59a4e2afde60a907dc6ee28a0712915ba7dfe5390f4"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_ventura:  "204d04c37fffe41d9a3923493bd1593aec8d7a8ee6a1797dc891b06a5d8a9a73"
    sha256                               arm64_monterey: "30817d635f16be7e5ced8a4de9e1d78d47529749aba0d85a0a1a09d5ebc80225"
    sha256                               arm64_big_sur:  "0927a32e9844daa9f6e089949d6a9531f5160ec28808ad6c94c9f28488ae5161"
    sha256                               ventura:        "d6a3f8f365c1ad5254fe6466fc8d67cfc5d68d25a27014f9a5d3bff67b445cdf"
    sha256                               monterey:       "49bad5119145ce0f703d41ce81a425c1a2a71a848c10c00511b27d66c546c4fb"
    sha256                               big_sur:        "1c84b75cbc32e96828d772dcd827e24417de7c1c2405a0d1729372da50d328b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f646e61c0c9296a9455d79dab5d4677f29c046e2cc62f077d2fbc7a903ba00e6"
  end

  depends_on "node@16"

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
