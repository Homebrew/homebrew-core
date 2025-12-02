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
    rebuild 1
    sha256                               arm64_tahoe:   "4842c436a2fefe7cd84e55e6db8764303cb94a462e3b7ca199e214b03beace46"
    sha256                               arm64_sequoia: "aa30dbad82098c555396fa5810915298e1da37226e8a7291269272038f0980f0"
    sha256                               arm64_sonoma:  "0ebb374eee2f64b48aadd1fb92d3a1ca0e17632fbff7916529477a3c4df68951"
    sha256                               arm64_ventura: "1243bab93e49d99e7e67fd7b90682eced4c2a5b935db8843e3d5c135fa2e5a18"
    sha256                               sonoma:        "4a0c34993fdc4c414a615f886f70804b6ff558301f4aff909b89a9b92e9c3387"
    sha256                               ventura:       "2a1b7c8824f911c7573de14d183862aa5baeed27922ede4b565fd1ae0236716d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44d682a12a7ae54d07cfd6ff865d923548b8febb035ef8d202302376ce9ba1c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f95e25d794cf25887927e9311a3d7558f175520361028c5296d2ee4be0cabdf"
  end

  depends_on "node"
  depends_on "unbound"

  on_sonoma :or_older do
    depends_on "gmp"
  end

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
