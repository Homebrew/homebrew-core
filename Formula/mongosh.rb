require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-1.8.1.tgz"
  sha256 "8592568c0a6adf6702d84ad449a97ff3c3de921187150f96607125190440101e"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_ventura:  "b8291ca80404ea896e1684fb42faec92c985e7c71826dd701f186e696a7a2099"
    sha256                               arm64_monterey: "138406a2feb07ae4f0066e90a53edbb6efe3772339e0155a115e4e9075ce7b16"
    sha256                               arm64_big_sur:  "91482ddb47d036ca9d780c450bcf63dd43d66f36f439d73706bf067a384b1921"
    sha256                               ventura:        "fba95a6b19daad242f6bb34b22a364d9a00e3c77b8d0810a7f85222ff43e8c03"
    sha256                               monterey:       "1f7b80c4c6244bcaf8295561283032d5564c988f8dbe0e1c3deb025d0375bed6"
    sha256                               big_sur:        "30674401c5a52342b5167b5ba63a39d956805f5bc68414a6eef7d876aa733bed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e898fb6f2283c1af9e1b215316ce0e6fade0b3f651b621bad01e9ac62e185437"
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
