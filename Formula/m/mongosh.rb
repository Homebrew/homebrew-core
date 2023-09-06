require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-2.0.0.tgz"
  sha256 "202d0b1decd6abdd4c8de25cc2e56ad749f9552a8493a042c9d1175337de2a9c"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_ventura:  "bf8421d71d5dff9706c1c4775a8a89d7977006b2ecfaf07db8b103eac9e74c21"
    sha256                               arm64_monterey: "3df26b51507754c808696faa820041829f31c523529f5b081a2ed08aa024b647"
    sha256                               arm64_big_sur:  "dac34c2cb2c1bdae6cd915480a52d73d52d77813ecf532a4ecca2d947bc99e84"
    sha256                               ventura:        "dd6e5358b3e403b1ea3037fbde81aaa0eeeb791247818329bcf4259164a4fc48"
    sha256                               monterey:       "3c4ed7eb788f17446424455e40d915598e8f9eb4d6321b23bcb5a98c65752c3c"
    sha256                               big_sur:        "0b567c68e45696b6b2f91001a827655eac9ed9ceb1764c7a2f04c03428f3815f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f767dab25c0fe933e4741b89f4cd5fd020b994bcabbbb1b3cb29ed03b8cc5f4f"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    assert_match "ECONNREFUSED 0.0.0.0:1", shell_output("#{bin}/mongosh \"mongodb://0.0.0.0:1\" 2>&1", 1)
    assert_match "#ok#", shell_output("#{bin}/mongosh --nodb --eval \"print('#ok#')\"")
    assert_match "all tests passed", shell_output("#{bin}/mongosh --smokeTests 2>&1")
  end
end
