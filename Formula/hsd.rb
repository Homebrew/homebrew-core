require "language/node"

class Hsd < Formula
  desc "Handshake Daemon & Full Node"
  homepage "https://handshake.org"
  url "https://github.com/handshake-org/hsd/archive/v2.1.5.tar.gz"
  sha256 "e53689784d677e4f729dd723e753038b020e030522e7c43b5dd753b7079a05f7"
  license "MIT"

  bottle do
    rebuild 1
    sha256 "dbd50284d8546d83bbe30663b99eeb5244fad4c0fedac0e673772b99300e0967" => :catalina
    sha256 "051254fac8a90d4069a7da8a56e17b16b926083d74bf699b34ab71d0c815bd81" => :mojave
    sha256 "0420b2d3785703c26a0c02f873d08463795e0bcee43a5f3bf871b28a7901ba40" => :high_sierra
  end

  depends_on "python@3.8" => :build
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
