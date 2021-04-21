require "language/node"

class Bcoin < Formula
  desc "Javascript bitcoin library for node.js and browsers"
  homepage "https://bcoin.io"
  url "https://github.com/bcoin-org/bcoin/archive/v2.1.2.tar.gz"
  sha256 "b4c63598ee1efc17e4622ef88c1dff972692da1157e8daf7da5ea8abc3d234df"
  license "MIT"
  revision 4
  head "https://github.com/bcoin-org/bcoin.git"

  bottle do
    sha256 arm64_big_sur: "3f32d6f05ed02b8b45a3b1c052e715b44cf73f22743695e912650606e6432566"
    sha256 big_sur:       "7f0a2c4421f671b938818178304792dc63b25baac528e0e3504a9d7962e58fe0"
    sha256 catalina:      "d8341943f3b0189a57ea03af05f87b86c40175399ea55e6ad1ca050edc7de43f"
    sha256 mojave:        "d2aa943d4b9b2c8e9c633c1b92f8eb3fa33ad22b98c087c2538e1524bec07bfe"
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
    assert File.directory?("#{testpath}/.bcoin")
  end
end
