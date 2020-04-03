require "language/node"

class Hsd < Formula
  desc "Handshake Daemon & Full Node"
  homepage "https://handshake.org"
  url "https://github.com/handshake-org/hsd/archive/v2.1.5.tar.gz"
  sha256 "e53689784d677e4f729dd723e753038b020e030522e7c43b5dd753b7079a05f7"

  bottle do
    sha256 "729378224e1496929dd73b03b7bd9d0365a1132a8702ca4e22555be908de63af" => :catalina
    sha256 "3fcfa8452139754cab058e8c3c2c5df240fc4379bd6b42989725d4219e872856" => :mojave
    sha256 "f9f7ce700f51d306e863cd4558ba60ceff775aef4994f83ec8c9ed7476522e12" => :high_sierra
  end

  depends_on "python" => :build
  depends_on "node@10"
  depends_on "unbound"

  def install
    system "#{Formula["node@10"].bin}/npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"hsd").write_env_script libexec/"bin/hsd", :PATH => "#{Formula["node@10"].opt_bin}:$PATH"
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
