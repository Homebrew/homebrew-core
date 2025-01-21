class Hsd < Formula
  desc "Handshake Daemon & Full Node"
  homepage "https://handshake.org"
  url "https://github.com/handshake-org/hsd/archive/refs/tags/v7.0.1.tar.gz"
  sha256 "b00b4250ccb56e42a0075263564bdc9a41b536d903b20af6cb2e87ca9a0e99a6"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sequoia: "a64c6370b1e09f25dfef73cc662a4781b72b977bf4a27a55ac346701fc71d9e1"
    sha256                               arm64_sonoma:  "93ece0122203241029f6aedb4817ee7f8a751fa9f7307c3b4bac5209eb096b15"
    sha256                               arm64_ventura: "23eb2c7aa7efe1c0719de0cd083cbff53c2fc09ade911da47e66d5d75b5427fb"
    sha256                               sonoma:        "01cd2eeaf3eb101e8d2f19cf7385168654053a875ca3ef071293918af1c52962"
    sha256                               ventura:       "7df4707762756df9e7f918c4fd4003f1fb45d492f11ae75a3d619e9984a14e45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "168fe038545e6dd92c6efaefc90aa7c8ffd6aa072e3be6c7a990f898a38c5b99"
  end

  depends_on "node"
  depends_on "unbound"

  def install
    system "npm", "install", *std_npm_args
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
    system Formula["node"].opt_bin/"node", testpath/"script.js"
    assert_predicate testpath/".hsd", :directory?
  end
end
