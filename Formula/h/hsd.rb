require "language/node"

class Hsd < Formula
  desc "Handshake Daemon & Full Node"
  homepage "https://handshake.org"
  url "https://github.com/handshake-org/hsd/archive/v6.1.0.tar.gz"
  sha256 "5eae5d24e1bace863e7cc52e3b95af66613e179a2dcc896642a7a2ce69801abf"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sonoma:   "ab61b874aa100661c7aa4c90e4f07b06557f367da4d7e70ad357ce05eef5abec"
    sha256                               arm64_ventura:  "026ce9081c77b9a5aa26770abac7a6b18304bf382b0e4da6a030e0e11815048f"
    sha256                               arm64_monterey: "2c00bde4691b91403be4535538ce60995b35721a7845af6abd8201c8455391c2"
    sha256                               arm64_big_sur:  "d5be878d38892d7c3ac9dbc98538cec12629df3d82e27f43b88d82dff5fd13d8"
    sha256                               sonoma:         "01475e73b6cd9da60d627c2da1dc27f0493de7bfca29e1710875d40b30b79450"
    sha256                               ventura:        "74b2a8b7e621b2cfa1ea48d08643a1ec09738dac92160b0c17827dbe3e54e069"
    sha256                               monterey:       "84e4ec6a4f64c8a4143214f9869f910854b342dedecd018255bae00eb21f00a6"
    sha256                               big_sur:        "1efc758aef083883e82dca7b67f5a631922d8278cb87efa053a5958eefe2600e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ee6a5e2349e7fdc3acfe28cf52aab45693aec37cff9c7963ceffb05c409844a"
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
