class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-2.5.5.tgz"
  sha256 "48f38d64eab47bab750b238be8233d43e2e703c2930a81eee3deacd0a3feb034"
  license "Apache-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256                               arm64_sequoia: "bd60e71de52d731d7d266bcca01d15a256b836255301c2140817581a97948395"
    sha256                               arm64_sonoma:  "962f207efac2990680658bac03e4c3eed0127a3915142d929cd5e77454a11bcb"
    sha256                               arm64_ventura: "f828ef2be94bbf018738ec80ef1606d4d52a01200111054b665bcbc73a6f7ed2"
    sha256                               sonoma:        "9c98f323d9610538df8bcfd203718bba280990fe1003944002fdd6e9ff68cda6"
    sha256                               ventura:       "9a91e56a2877cd4036921826bc2cab71d6418b040cefcd6c2f988a4690e75683"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8d0efaadbaf874c0497f06828401961ffd482a7eda63bd128a4779e96e8f30d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1259592579c1a856fb8d1ebc526a9a37ba78ddfdb9df37ed549f4f85020fabf"
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
