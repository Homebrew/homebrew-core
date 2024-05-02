require "language/node"

class Hsd < Formula
  desc "Handshake Daemon & Full Node"
  homepage "https://handshake.org"
  url "https://github.com/handshake-org/hsd/archive/refs/tags/v6.1.1.tar.gz"
  sha256 "6a0040832f92b08973b2eb5dd350ee7b6cb20234b0d523f133b935e876e9d9a6"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sonoma:   "61c2aa6a86c332b29b03754702df5e26cb6e263eb6a25df50c19ecf27794643a"
    sha256                               arm64_ventura:  "2f3102a965e2e4ce59a7702309301cf448e89bdea3d370f489b38310aa1298d3"
    sha256                               arm64_monterey: "42f2b274e0732cdde5412969b9200ffc32b1fd38818ea4c79901ac6b986448ab"
    sha256                               sonoma:         "373070fc85e6e71ba588c7ed147c9ca5dfbfd7d8658687b8ff0b35b8f744bdac"
    sha256                               ventura:        "ee3f6cc11f3a8b7d403a2881c68c2bc25046553f03f85b787115a918351b0cc8"
    sha256                               monterey:       "2e68c505a331dce0c06e9dc3446d4d0586dbaee5caf4e4d9e35a5256654e915d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c48b88c9874c7717a3ca4ef378bd3a9233d3fe73cacc9ed56befbf8aeb316e17"
  end

  depends_on "node"
  depends_on "unbound"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    (testpath/"script.js").write <<~EOS
      const assert = require('assert');
      const hsd = require('#{libexec}/lib/node_modules/hsd');
      assert(hsd);

      const node = new hsd.FullNode({
        prefix: '#{testpath}/.hsd',
        memory: false
      });
      (async () => {
        await node.ensure();
      })();
    EOS
    system Formula["node"].opt_bin/"node", testpath/"script.js"
    assert_predicate testpath/".hsd", :directory?
  end
end
