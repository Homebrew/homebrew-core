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
    sha256                               arm64_ventura:  "13f36e7d5ce43f4c433576fb905e227f2eb8f87deae20f71b9e67405043239b5"
    sha256                               arm64_monterey: "c1962aa290d5f128550ae881524b43cab399393ea28f4847afe9d2a1a99c0c42"
    sha256                               arm64_big_sur:  "e10e342c0e4c83596de9bb5752a21fd34d914c807a44be2c1bc8ef4ddca6ad96"
    sha256                               ventura:        "af4c9706437551e6d4bb704d53a0878379148c81422ecf6745c5f83202fb7272"
    sha256                               monterey:       "1266ce92302ceeace08342629c5c3683a2e49118ea48858ed01f37d53a3a1440"
    sha256                               big_sur:        "47093caa245ff57f0d98422784b225add6341722f20c57f5a9a82920652ca65a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d07e51508c6823ac3aa62f1cffa02a813c9dc96e72b1690e176dd72f2cc8e71"
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
