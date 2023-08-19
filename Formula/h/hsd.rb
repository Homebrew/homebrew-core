require "language/node"

class Hsd < Formula
  desc "Handshake Daemon & Full Node"
  homepage "https://handshake.org"
  url "https://github.com/handshake-org/hsd/archive/v6.0.0.tar.gz"
  sha256 "1f07826ecc286fb80a20174e1b958bae9408270f65dc25021d02407e3696f060"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_ventura:  "0b6bf59d02584210a68f0cf04728f85319cd134e62b55b51090079911bfb30e3"
    sha256                               arm64_monterey: "f3b00ab458925affd02fb786353bc550a91602aa7938fbf3bb4165825d56a226"
    sha256                               arm64_big_sur:  "d42321c8c5e790d127ddfd4ad73c73326818ae4a31c60a2a70cef775bf32af62"
    sha256                               ventura:        "b0c30462c393fb7803c7e8db884a8ee54622160c66b539d767906efacd78ea25"
    sha256                               monterey:       "a73971fdbe43045eff09427c71b4e3b93804f781fd72d37dfb938ead9ee470d2"
    sha256                               big_sur:        "ebb7896590500b4a90ca1cb29c7f2df51ab21e480f787ed9fa1c5e8f7f675b68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97c07bd4b0d19b92b7edbd49694b7b9c27cbfcfaa66f10db7134081d631517cc"
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
