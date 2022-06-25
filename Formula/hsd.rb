require "language/node"

class Hsd < Formula
  desc "Handshake Daemon & Full Node"
  homepage "https://handshake.org"
  url "https://github.com/handshake-org/hsd/archive/v4.0.0.tar.gz"
  sha256 "a5de4a14f99097b97ebaae1b88ac0d222e9455d4e882ab1386f53e36eecb026c"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_monterey: "14cd2a1cbfef894da9c6dc09a90d4223b0a0da77c6f2b6f93fe3f89a11f550a3"
    sha256                               arm64_big_sur:  "840be4bd77ad3f70ba6e0d6ebb3522f7379868735c86d05aae6d4be9bc764f9e"
    sha256                               monterey:       "921e97b08e25de8bc1f253a2f72b96be2e7ba36a0cd0fb23b2f4e1307c6627b7"
    sha256                               big_sur:        "5a376648781176d3e4f59baae1428345e27839cae03464d391e14c67a662919f"
    sha256                               catalina:       "3c6a69ba29c654ba062afb73105ea97106c16ca7206883f9a04b4e95b0a3774f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af72ad309229f1a167eb2ec09fe17d73613f9f93b9c105a0610fad0ebff264c6"
  end

  depends_on "python@3.10" => :build
  depends_on "node"
  depends_on "unbound"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
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
    system "#{Formula["node"].opt_bin}/node", testpath/"script.js"
    assert File.directory?("#{testpath}/.hsd")
  end
end
