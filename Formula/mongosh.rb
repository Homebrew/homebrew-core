require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-1.7.1.tgz"
  sha256 "ceb206a224d0130dcba409b9389f4e7982deb54163e332f7aa729853d8cf6120"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_ventura:  "760d2de70462e9b02fc7217cbbb35d599ae8d8eda788c0537ed913b2f8e4fde6"
    sha256                               arm64_monterey: "ba4375dc5836e35647f8e9d2c742f9cf5d59b4ed990321903989e08395c7f635"
    sha256                               arm64_big_sur:  "edefc603baf295508365ce62273e001d69a594309bf6efeeecc81cf115cadb94"
    sha256                               ventura:        "9e1dd550e9dc1a13a39fa451f6db85dfbaceb8af33dce449cd2151a733249456"
    sha256                               monterey:       "4a88ebc873f7fb935bc753b4489348684397d4659edc7345fbbe5fdd3aa5f554"
    sha256                               big_sur:        "d6daac98f354dec24af4fa5f4b2cc177408ca28a838d04089f58f99a638c18d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a92d84d84344978c7e7d4c1f0a88da5c6d44589dbb37f176f86516745e6c4f2"
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
