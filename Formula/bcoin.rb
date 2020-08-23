require "language/node"

class Bcoin < Formula
  desc "Javascript bitcoin library for node.js and browsers"
  homepage "https://bcoin.io"
  url "https://github.com/bcoin-org/bcoin/archive/v2.1.2.tar.gz"
  sha256 "b4c63598ee1efc17e4622ef88c1dff972692da1157e8daf7da5ea8abc3d234df"
  license "MIT"
  head "https://github.com/bcoin-org/bcoin.git"

  bottle do
    sha256 "108903ff8f06a500be27e4108b65c4462c469f778a23b41b697f21c99d19df5f" => :catalina
    sha256 "c8bec139df5f6b3e8b40179dab802dee9b7480d80c5503f620d8ac843479e274" => :mojave
    sha256 "aaaccce8be6e2c06276627d4ce705039530ba228b378b5f670bc83124f649b32" => :high_sierra
  end

  depends_on "python@3.8" => :build
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
