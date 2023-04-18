require "language/node"

class Hsd < Formula
  desc "Handshake Daemon & Full Node"
  homepage "https://handshake.org"
  url "https://github.com/handshake-org/hsd/archive/v5.0.1.tar.gz"
  sha256 "545c50358232bc6003b6de1ea95cc20e4918778afe706997c61089420484676b"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_ventura:  "0864a8c79a0a9abf3e5de9ba4a29d40dbf87f46955f3e8a572185297f9c85651"
    sha256                               arm64_monterey: "549fdec6f1529239a5e57f2d61f1d524a9976913f7866cfbb3c2f3f1e3c57883"
    sha256                               arm64_big_sur:  "773e274d9ea8c436891d1dec21724bdd303c0fdf6534d1b0387720ddf69ea961"
    sha256                               ventura:        "2fb720854ff59869b3647a484b52c697542b0903180872e25a6211016f6c59e2"
    sha256                               monterey:       "b084f090146ce1fd7eb4a55d33b7db08e964a271127efbfe76713547284da4f1"
    sha256                               big_sur:        "f61ec0c9cb4d9aeaf9337d185c6c6cc7282fade49a9dc004f3834fcc370da78f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de24c62e30033c7338df415559a28f26e0a2ee07fa0317f24e57e9924d65038d"
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
