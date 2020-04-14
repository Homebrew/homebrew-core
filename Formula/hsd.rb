require "language/node"

class Hsd < Formula
  desc "Handshake Daemon & Full Node"
  homepage "https://handshake.org"
  url "https://github.com/handshake-org/hsd/archive/v2.1.5.tar.gz"
  sha256 "e53689784d677e4f729dd723e753038b020e030522e7c43b5dd753b7079a05f7"

  bottle do
    sha256 "db98049e6689a72c86b560b8a9bc5926114b1af9271ecfb51e23d591a3f4012a" => :catalina
    sha256 "91622dc051c25648f5a533cd0c227670800be9718b47bb33b29181fb7151ecaf" => :mojave
    sha256 "3efaa9f3ab569d428064329dbceff2426c65ffaa939a905a872a8b154c1f6a9f" => :high_sierra
  end

  depends_on "python@3.8" => :build
  depends_on "node@10"
  depends_on "unbound"

  def install
    system "#{Formula["node@10"].bin}/npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"hsd").write_env_script libexec/"bin/hsd", :PATH => "#{Formula["node@10"].opt_bin}:$PATH"
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
