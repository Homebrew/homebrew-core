class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-2.4.2.tgz"
  sha256 "a7810f62078670ca57bdee2aad9f7a79b14771674956d73cc28aac7367524a76"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_sequoia: "81db3062a489c6f4995e317fd50d47859f6439f8cc45e533978e8ad96af46770"
    sha256                               arm64_sonoma:  "d1d5008c4d0c1b7ac6b492b9e70a6d0c0181bb21f6abd2100b1b341f5e5c7a61"
    sha256                               arm64_ventura: "0841e043881f8da6cab474952bb4c992643f0ddbb33d329dc5787715a0ef2b8c"
    sha256                               sonoma:        "ec7fbb0a0100af4c4103b64bab670aa002442a0736cf112ef7e7567254ecccc7"
    sha256                               ventura:       "898224fbccb685ad3fa571aa293913bb6a243c4e3dda6fc9bf46347df111dfe9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac675ebaeffd31ad3a09635a47ac59bea21cf34f47c66d13f63ee4da016b8c64"
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
