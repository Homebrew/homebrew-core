class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-2.4.0.tgz"
  sha256 "c8d3eae160a892e32837db3dcae515e843e5383fef52b8141940c8bcf8b6d59f"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_sequoia: "58ecbde5d437a955ee5f2b0766ead6bbe6994e0284dcb3a0372d6adb4ff7bc33"
    sha256                               arm64_sonoma:  "c46432652b9a1893576921b7e8246411ac0f028368a70f22772dea4e0239cf4f"
    sha256                               arm64_ventura: "fe495897766b2cbec604c8cc8d1ae05bc26ace53f7f2e8b829c2d2b97786acb1"
    sha256                               sonoma:        "365709490ac995231bcbcd8ad49f20caae294871a0ab009917be9289890d0a50"
    sha256                               ventura:       "3d61c59c6fdd5f7c30b0032a72615841f9ce5c83b2ac8c9630e9d77b0d8adb61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87e6230aa8f89ac25719e3f0f2b2f3b4ca65cb16ab27f3d54a1a828019df9d22"
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
