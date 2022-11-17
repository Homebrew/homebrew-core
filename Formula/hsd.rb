require "language/node"

class Hsd < Formula
  desc "Handshake Daemon & Full Node"
  homepage "https://handshake.org"
  url "https://github.com/handshake-org/hsd/archive/v4.0.2.tar.gz"
  sha256 "ee58d681491bee90299ea2fa18656ac26fc6aef2bf3e363cb996be5015b06feb"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_ventura:  "84ebc75554473cb29d2d039262f3c9e12bdd4111ebb0876e6e8d6d72a81b639a"
    sha256                               arm64_monterey: "322295b784df6ecc6d4ed5cae4957589fba6f59662a38467cd7a16465161a7c4"
    sha256                               arm64_big_sur:  "92a27b35ba52bcd1aab836d70720cc8e0a343ef2c05a035dd038e95948bf9e88"
    sha256                               monterey:       "333dda4bf02aed146bf4ae7c1458ac31dcd1ff9bdf0a5f7d25bdeeb88a711b64"
    sha256                               big_sur:        "5ff1b677c57757866eb2acd527f62a7582160fe2af6cf9f1334f298a93c7455d"
    sha256                               catalina:       "d13d7d46267337411111f127468ee825be178a80d3135bd68756589f54856641"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7eceddba39715d8c8d2a44add1bff762f2dd580786911bd9f44d258da0184227"
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
