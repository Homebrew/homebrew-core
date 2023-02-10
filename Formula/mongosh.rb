require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-1.7.0.tgz"
  sha256 "635923887568911b4fe373b1cf8d340e6cb6e7c5bce745056e66b9477126cadb"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256                               arm64_ventura:  "5e40dc8eeebbcd1eaa81c951d5ba76c2f5824ec4e08b99cb9a0f04b897f0b87a"
    sha256                               arm64_monterey: "33f6d51c16b1b5bc6924bcd71322b000dd472ea46f2e53a387b25796c4c4e435"
    sha256                               arm64_big_sur:  "c0f8194aa02e293eb4cdf1c57c982ca914e7844b3675e0edf7b73978fb441e1f"
    sha256                               ventura:        "b564d289ca3f268cf88f0b948a36b2907821a8428cdf0d2b6d414e39a928cc23"
    sha256                               monterey:       "6a13b38fd74ebb879af9026a3e2cbaafbc7099a3047fe294bd918dc93534b76b"
    sha256                               big_sur:        "9e620d9c1e9831639dc3cdf7b6b1eefe08ceb889b27bd632d883b75270df1ca7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5319e9ae54cd2f68dd19fa0e99b47a6e0f3d0673a0e817e07e5d6c17e1cec286"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    assert_match "ECONNREFUSED 0.0.0.0:1", shell_output("#{bin}/mongosh \"mongodb://0.0.0.0:1\" 2>&1", 1)
    assert_match "#ok#", shell_output("#{bin}/mongosh --nodb --eval \"print('#ok#')\"")
  end
end
