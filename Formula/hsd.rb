require "language/node"

class Hsd < Formula
  desc "Handshake Daemon & Full Node"
  homepage "https://handshake.org"
  url "https://github.com/handshake-org/hsd/archive/v2.3.0.tar.gz"
  sha256 "1787d1e35288494724eaf3144bba9e061613048d34b5babd38b6c52995a15a72"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 big_sur:  "33e844aa1841d7492c1b34d9de70242c26ce94ae5c90cc4b82cd319ae73be9e2"
    sha256 catalina: "5ea75133f88879508221fea5c747b14d4839f4d0892187bec8441f28d347ca1a"
    sha256 mojave:   "8ad56895ec82c5a673c230c18e3b8def53014cef39cbd6f428292d1405b17da5"
  end

  depends_on "python@3.9" => :build
  depends_on "node@10"
  depends_on "unbound"

  def install
    system "#{Formula["node@10"].bin}/npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"hsd").write_env_script libexec/"bin/hsd", PATH: "#{Formula["node@10"].opt_bin}:$PATH"
    bin.install_symlink libexec/"bin/hsd-cli"
    bin.install_symlink libexec/"bin/hsw-cli"
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
    system "#{Formula["node@10"].opt_bin}/node", testpath/"script.js"
    assert_true File.directory?("#{testpath}/.hsd")
  end
end
