require "language/node"

class Hsd < Formula
  desc "Handshake Daemon & Full Node"
  homepage "https://handshake.org"
  url "https://github.com/handshake-org/hsd/archive/v3.0.1.tar.gz"
  sha256 "2952dd9fe5c1d5db448e0881cc1656c5efaa61cb6030c4bc629e04f53feec3b4"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 monterey: "3ce9eeb620102eee12e5153ccb3dc4d53d12cb3b9701e1db7a7b1de52c11ba19"
    sha256 big_sur:  "edd5c51a0b30b879e7be8feb6d5a30614249d7b1313743ff6281b3f5e9ea5946"
    sha256 catalina: "32607b1d4de029dfe5be50508b30aca83ee087a5e43fad5e275c4b753ba28c57"
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
    assert File.directory?("#{testpath}/.hsd")
  end
end
