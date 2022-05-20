require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-1.4.2.tgz"
  sha256 "6a365afc8a67d865416e0627eeb7e9512cd0b1686fc80072750b7de075c863b6"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_monterey: "fbb0f6a68690d96d544e7bc4777813328ba598b4e528c6c119d0af6e990a01a7"
    sha256                               arm64_big_sur:  "448ff34b23312987dc11b6853ec4aa9b2e6bfacc60aa45bcc9eac1d65eefd123"
    sha256                               monterey:       "64afc2a7d853d5074805ef0b84f473b39ea4e3cd7a2d308820adebe6d8d09741"
    sha256                               big_sur:        "28251b2b0a436baadf8f704875a216e57c6dd3d5bfb43e24a1a8611041a6f1cf"
    sha256                               catalina:       "2277b3b7da3c693e7b57a9c53d5e4d307c0cf6dfb3aaed5952f5e0690e9000df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "092c63828584166bcdee219763387d84d7dcf7f3497358842d223883e3cc23b2"
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
