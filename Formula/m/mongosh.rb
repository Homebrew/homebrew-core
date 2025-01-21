class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-2.3.8.tgz"
  sha256 "a29a704bd09845dc3ca0324fe31fa1c8b2f9dc636017a8859b875f7a28f814b5"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_sequoia: "6e735ca5983b92cb63fa5ccd295d86d62f03e38130fed903b92c6b1331f604aa"
    sha256                               arm64_sonoma:  "5c2ae44747a4bfb06502723ecbedc12e5fbfa07f9bb93e0e5c9683df908af6fc"
    sha256                               arm64_ventura: "46ba4388a9b4a4db1f8bf5eba1cd013cc48d6af614a0c8847ae4fb3e12acdb6f"
    sha256                               sonoma:        "53150b60a4b268bd17af4b106129ea79fb0b2ee9a8dc11e1981d61343dcc2e4d"
    sha256                               ventura:       "85c218eb3f0d173762add2ee8cbe48cbc7be9a8a8fe1d3bd197f50b71549f00c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0b03c89dd4d120251d3d16cffdd8f520a0c9f3db1fc7e62608490d528fa72c6"
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
