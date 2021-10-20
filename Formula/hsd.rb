require "language/node"

class Hsd < Formula
  desc "Handshake Daemon & Full Node"
  homepage "https://handshake.org"
  url "https://github.com/handshake-org/hsd/archive/v3.0.0.tar.gz"
  sha256 "5c76470dbd876ce907b6e75b6532328bda7739f3a93b284c87355343fea5de8c"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 big_sur:  "c8212a8fa0a8d4044f115925389b702be68d2fa9fad513347d027b533e7e9bca"
    sha256 catalina: "d98c2a163023c740f9bf9fc8eee2f4371bbbca80400ad5387ff75c006106e859"
    sha256 mojave:   "d43b5626c0cb9126bdc4fd290a80cedd7aea078c5c87364dde43876990d999ae"
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
