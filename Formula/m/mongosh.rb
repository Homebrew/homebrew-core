class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-2.4.2.tgz"
  sha256 "c8d3eae160a892e32837db3dcae515e843e5383fef52b8141940c8bcf8b6d59f"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_sequoia: "e21cc25d0c348d22245c31d07045891e5924ed4f4ef3bf25247924f034f17487"
    sha256                               arm64_sonoma:  "629f8f106865b50d8e645af60596d3418a6f8225097b402c22c83e35d58265c9"
    sha256                               arm64_ventura: "c0799729aed6e879538144d309e127455721d0d1185c798ced0f2124b017442e"
    sha256                               sonoma:        "daeace43e0a59d840d8f7c376996ee7a3411a7369118b00e8f90728570e94441"
    sha256                               ventura:       "7f77dd4b5c04520ab069675c56da30c4de4f313bed1658205aa2f6ea5100cfee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e692eb52d4d4d8acbf2195bd71be30592539548cf5c572394a10fc6127056c86"
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
