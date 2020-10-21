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
    sha256 "408858a3f5353615b6ebd052ae5d8ecb2707c0575ecd0fd8993ceacf7d80338e" => :catalina
    sha256 "fc3226b4ec0341accfb96e26578ce631b12259bafb83ab3ee118c67aab2ac896" => :mojave
    sha256 "72ba73b25be636e27aaa14267bfb0e8383ffdb484f73b1ccc88c55fc9b7ae28f" => :high_sierra
  end

  depends_on "python@3.9" => :build
  depends_on "node"

  def install
    # These dirs must exists before npm install.
    mkdir_p libexec/"lib"
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
