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
    rebuild 1
    sha256 monterey: "aaebc4a1b12cede16789eb794d9351d638ddebc3bde2332ee1b80e0fcf84480c"
    sha256 big_sur:  "2c55dd9db7cd9e0cd53aaeb684211fa5a83ecd3f2feec5233aa4087f6750da26"
    sha256 catalina: "734bc1a659c1c148299eb76eb099247709079a0d21aa0c807cde6dc7d88a4cf3"
  end

  depends_on "python@3.10" => :build
  depends_on "node@14"
  depends_on "unbound"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"hsd").write_env_script libexec/"bin/hsd", PATH: "#{Formula["node@14"].opt_bin}:$PATH"
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
    system "#{Formula["node@14"].opt_bin}/node", testpath/"script.js"
    assert File.directory?("#{testpath}/.hsd")
  end
end
