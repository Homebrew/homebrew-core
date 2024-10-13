class Hsd < Formula
  desc "Handshake Daemon & Full Node"
  homepage "https://handshake.org"
  url "https://github.com/handshake-org/hsd/archive/refs/tags/v6.1.1.tar.gz"
  sha256 "6a0040832f92b08973b2eb5dd350ee7b6cb20234b0d523f133b935e876e9d9a6"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256                               arm64_sequoia:  "38370bba9da2a34a815b8d9d2c1db0b4f966e7cdc80e9bcc2d56260c00fef966"
    sha256                               arm64_sonoma:   "aca335ee9c1ce485ff2707794e8266a99364f54126c52aa51a017516416469a5"
    sha256                               arm64_ventura:  "724d34587826a5fbc70b8261c6cd5731615db65885792ee06eabc465de47f641"
    sha256                               arm64_monterey: "63016ff5b01c5817c264334ae73ec6563bf1407fe2c4d075e42fb9f48e9a4a20"
    sha256                               sonoma:         "d868bb06dfe9b7249563131e6d0aefcb0ca78ec8edfafec38ed34127b740484f"
    sha256                               ventura:        "92e1242289174273f88b61eaf3f27a17aee31498dd8f838fcee9eb76f0ae6195"
    sha256                               monterey:       "e823e72e815659ec79d23f9232697bcb800da16d2634b47010e7e7e303b3d07b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b725ebb4a9c05cc211b83a4932c53cd8054140bdbb62071bb7cccd34715be01"
  end

  depends_on "node"
  depends_on "unbound"

  def install
    system "npm", "install", *std_npm_args
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
