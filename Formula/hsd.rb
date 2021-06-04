require "language/node"

class Hsd < Formula
  desc "Handshake Daemon & Full Node"
  homepage "https://handshake.org"
  url "https://github.com/handshake-org/hsd/archive/v2.4.0.tar.gz"
  sha256 "8de104d55fd50c458d7a1d3e3fc1fa6e9398b97f9b639416a01b19f853dfcf60"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 big_sur:  "2d849b6056ad70220df056474d22acc75f67d7393e791de5cd03be373cb38daa"
    sha256 catalina: "66dc553d9f6889a82ffd8994e7403fd106bc9f388ba9fb29c06ee770739d90ee"
    sha256 mojave:   "22148799a8b3f468ba46236e9686d0130bbea86b0cc1ed01b1db022ec9dd6e2e"
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
