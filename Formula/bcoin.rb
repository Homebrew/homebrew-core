require "language/node"

class Bcoin < Formula
  desc "Javascript bitcoin library for node.js and browsers"
  homepage "https://bcoin.io"
  url "https://github.com/bcoin-org/bcoin/archive/v2.1.2.tar.gz"
  sha256 "b4c63598ee1efc17e4622ef88c1dff972692da1157e8daf7da5ea8abc3d234df"
  license "MIT"
  revision 2
  head "https://github.com/bcoin-org/bcoin.git"

  bottle do
    rebuild 1
    sha256 arm64_big_sur: "f401dfcda058e68165418880973b275201dd372734fb866de7a51f6a48c0e6ce"
    sha256 big_sur:       "18e9b1f2074c5c98b15cb118b72a6104db12e9c80bc56d4c74374d86f394dece"
    sha256 catalina:      "3f46d506838e38420dc9ed5bd5b8c5c3ae8038bea02fad83f36f1ed36cda9046"
    sha256 mojave:        "5adbc476b4e3ef00c5e8fe7fc1554a891b4a3b09bd5d318103d0ac44f7540d80"
    sha256 high_sierra:   "c4bdb0a86a7fbfce14261af58ab4954c93f2eba09806a6933959fdfe8698878d"
  end

  depends_on "python@3.9" => :build
  depends_on "node"

  def install
    system "#{Formula["node"].libexec}/bin/npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"bcoin").write_env_script libexec/"bin/bcoin", PATH: "#{Formula["node"].opt_bin}:$PATH"
  end

  test do
    (testpath/"script.js").write <<~EOS
      const assert = require('assert');
      const bcoin = require('#{libexec}/lib/node_modules/bcoin');
      assert(bcoin);

      const node = new bcoin.FullNode({
        prefix: '#{testpath}/.bcoin',
        memory: false
      });
      (async () => {
        await node.ensure();
      })();
    EOS
    system "#{Formula["node"].bin}/node", testpath/"script.js"
    assert_true File.directory?("#{testpath}/.bcoin")
  end
end
