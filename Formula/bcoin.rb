require "language/node"

class Bcoin < Formula
  desc "Javascript bitcoin library for node.js and browsers"
  homepage "https://bcoin.io"
  url "https://github.com/bcoin-org/bcoin/archive/v2.1.2.tar.gz"
  sha256 "b4c63598ee1efc17e4622ef88c1dff972692da1157e8daf7da5ea8abc3d234df"
  license "MIT"
  revision 4
  head "https://github.com/bcoin-org/bcoin.git", branch: "master"

  bottle do
    sha256                               arm64_big_sur: "03cd2231a1a9761a6e55696ac3285930b18193a390a4e327227e0ed71c4ad350"
    sha256                               big_sur:       "f5ea48d98b345f76dba628c6fca49f1202e214a8ed265109d898716b689198f4"
    sha256                               catalina:      "cbc374b70e39ec6954a58f1c69cfb357121df495da3e2e5b51d6ce590b35de92"
    sha256                               mojave:        "4e8b2f111b3643712058823c9af5c1650ce64c7d5757e30c1c58d3d34dcac8ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46f97e509af3ecc06af837d1f6d5987f3da8026cb280f9641736b840d7ad8b89"
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
