require "language/node"

class Hsd < Formula
  desc "Handshake Daemon & Full Node"
  homepage "https://handshake.org"
  url "https://github.com/handshake-org/hsd/archive/v2.2.0.tar.gz"
  sha256 "44baccfd4940131a1ef97d4fb4632a9c3f59a081b2f08e89a0c8e171052fc9d3"
  license "MIT"
  revision 1

  bottle do
    sha256 "1313e41c8cc2c88a884e39cead4de454d30a688a69102357f39f12d40d4cd005" => :catalina
    sha256 "5963bdc9f5d671e661074a29d9ad58a6aa33ba781ea29d48dce359758d7a3bb0" => :mojave
    sha256 "96d2753d93d0ec184fcbf821c71d1517710cdeb28219198bcc730ab9b6748490" => :high_sierra
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
