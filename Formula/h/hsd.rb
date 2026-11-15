class Hsd < Formula
  desc "Handshake Daemon & Full Node"
  homepage "https://handshake.org"
  url "https://github.com/handshake-org/hsd/archive/refs/tags/v8.0.0.tar.gz"
  sha256 "1de0ebbbac6ca35d62353227176c7377203a82efbc27fdf08ad23dedb481ee28"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_golden_gate: "8a85892f70479ce2220e75b73555fefc130511d48c76eda38777697538314953"
    sha256 cellar: :any, arm64_tahoe:       "36611c3df02c5cdc5ca4e1d0a5ccff743dbb13bae2ef19a4c26047344b3b0436"
    sha256 cellar: :any, arm64_sequoia:     "6d90276a5d657b913adce32aa66275711de9e470110a786e073d011f82ddd588"
    sha256 cellar: :any, arm64_linux:       "ceccc5cbaf898894a713b9b8bea6ebf2a2fc435aa9b272d8efb478d4f74d1d04"
    sha256 cellar: :any, x86_64_linux:      "5f7128b4e22bf488817ca133b88e27db73dd9b027bb2a71c65892724bc2d5be1"
  end

  depends_on "node"
  depends_on "unbound"

  on_sonoma :or_older do
    depends_on "gmp"
  end

  def install
    system "npm", "install", *std_npm_args(ignore_scripts: false)
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    (testpath/"script.js").write <<~JS
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
    JS
    system formula_opt_bin("node")/"node", testpath/"script.js"
    assert_predicate testpath/".hsd", :directory?
  end
end
