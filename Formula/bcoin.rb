require "language/node"

class Bcoin < Formula
  desc "Javascript bitcoin library for node.js and browsers"
  homepage "https://bcoin.io"
  url "https://github.com/bcoin-org/bcoin/archive/v2.0.0.tar.gz"
  sha256 "ff99b735d3b23624455d72eada0de7f7ba4207f4a4cc0cab963ca2036de254a3"
  revision 1

  bottle do
    sha256 "4213df6b695d8fef6991a6d8a911b23599b8539487d5a6f1897d95845a281efc" => :catalina
    sha256 "c7f4e5ff082cc63eb342c1f6ec5f88480abc12bddcdd5d310c1514496904ea62" => :mojave
    sha256 "3054378525f593ac70a13a139ef5be6f343c7c0e22cedffee2b98b44020e0cc6" => :high_sierra
  end

  depends_on "python@3.8" => :build
  depends_on "node"

  def install
    system "#{Formula["node"].libexec}/bin/npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"bcoin").write_env_script libexec/"bin/bcoin", :PATH => "#{Formula["node"].opt_bin}:$PATH"
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
