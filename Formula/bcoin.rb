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
    sha256 "b70e1482829bad93ab67cc8eb466fc6278a73d3df8ea1bf71c017d7c5aead94d" => :catalina
    sha256 "7daae17e8a2d2cba2373855e4c795cef9fe75211f06ce084c24fba89137fcbe8" => :mojave
    sha256 "b405e5f6ad2987e380259fb75a6acfb07d9b6fc0eadc444b8277fb47bb384056" => :high_sierra
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
