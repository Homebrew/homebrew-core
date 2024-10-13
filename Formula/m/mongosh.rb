class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-2.3.2.tgz"
  sha256 "1836a58f01ca54936094be676c722b01a1ee6571b8cc60cd81664c73a98f4831"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_sequoia: "db5d98bcd32913ef4c1a3eb325d468ab9b9ae3e304501e8325560176a0d3dadc"
    sha256                               arm64_sonoma:  "08c06871a3de08dfc5bc5b9f5ce7c4120c135ed83045dec00797cdd4c1860421"
    sha256                               arm64_ventura: "c62a3a162a9297b1cc8af6125c040d59c7793bda5963e91a01efb0891dfc4158"
    sha256                               sonoma:        "2438c6192dd7481f89070ff36dabe184d53a9cb17135295b3b7751d7a38d3049"
    sha256                               ventura:       "f75ba86a100479e87fd1470b82c649f5e45e3aae59d06a844483196693265798"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e25f16f2faa89e58f2c12fe69eb64e7198f49f33eec1a23612cb827c307817ce"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "ECONNREFUSED 0.0.0.0:1", shell_output("#{bin}/mongosh \"mongodb://0.0.0.0:1\" 2>&1", 1)
    assert_match "#ok#", shell_output("#{bin}/mongosh --nodb --eval \"print('#ok#')\"")
    assert_match "all tests passed", shell_output("#{bin}/mongosh --smokeTests 2>&1")
  end
end
