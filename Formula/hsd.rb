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
    sha256                               arm64_monterey: "4eb83141deaf67b7671bf63bf04c29d45ffaf7a1b109fcb24c4aa3f06e88a710"
    sha256                               arm64_big_sur:  "5e6b6ebc5536f78e46706c0452450c142564b4878de8f82d51a525d1a4448362"
    sha256                               monterey:       "141f151e55e83daeba366eed66c6b8c9f36a6d32197b6c39e3d8880f891c93c3"
    sha256                               big_sur:        "0fc8ac12bc30f796c3cdd1720edea91fd142f3e48304adf146884e1d6fd78694"
    sha256                               catalina:       "68327ad96c5990bf38f9f3633ada1f0df63292d9ece40e29175f173de96c292b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71d79ecdc8e6d7991692b4d9d6de9e5aa0a3632f4508e124cc879d07ce7b6b10"
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
