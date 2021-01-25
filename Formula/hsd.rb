require "language/node"

class Hsd < Formula
  desc "Handshake Daemon & Full Node"
  homepage "https://handshake.org"
  url "https://github.com/handshake-org/hsd/archive/v2.2.0.tar.gz"
  sha256 "44baccfd4940131a1ef97d4fb4632a9c3f59a081b2f08e89a0c8e171052fc9d3"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 "b1281ad7121e7e98f444545ed03895bf6ea2cfe2b854246e2042d8a8a1d7cc80" => :big_sur
    sha256 "e2ba2aca6a02bec6b19bda5bae90d3cdf55dcb2d04c06e10c2c165fe6d2355ce" => :catalina
    sha256 "d1a1258ab1bb0223fa817e87ee97bb0135505c60e8b33fc6d7529ee9e19bb522" => :mojave
    sha256 "d6b9f39026b26a371e17b689e09b559a375ad04705e4d0ed65da2400a8a0fd33" => :high_sierra
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
    assert_true File.directory?("#{testpath}/.hsd")
  end
end
