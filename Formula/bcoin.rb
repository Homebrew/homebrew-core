require "language/node"

class Bcoin < Formula
  desc "Javascript bitcoin library for node.js and browsers"
  homepage "https://bcoin.io"
  url "https://github.com/bcoin-org/bcoin/archive/v2.1.2.tar.gz"
  sha256 "b4c63598ee1efc17e4622ef88c1dff972692da1157e8daf7da5ea8abc3d234df"
  license "MIT"
  revision 5
  head "https://github.com/bcoin-org/bcoin.git", branch: "master"

  bottle do
    sha256                               arm64_big_sur: "728c2a8cb144edbcd2e0174a30f13eb62be21217c7f5a12a1e8d9a9ca30228da"
    sha256                               big_sur:       "93b20a88905a0618fdcaa7e4802a52112297e5352a893b086ecd582a9b4f4cfe"
    sha256                               catalina:      "e84084b15935bd9c85fee85b902cbbedb3a57e71cf80307878e7fc47964f74f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40c658b3c5f910037d531193d08cef916272f71fe6193543b05497db804f24b6"
  end

  depends_on "python@3.10" => :build
  depends_on "node@16"

  def node
    deps.reject(&:build?)
        .map(&:to_formula)
        .find { |f| f.name.match?(/^node(@\d+(\.\d+)*)?$/) }
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"bcoin").write_env_script libexec/"bin/bcoin", PATH: "#{node.opt_bin}:$PATH"
  end

  test do
    (testpath/"script.js").write <<~EOS
      const assert = require('assert');
      const bcoin = require('#{libexec}/lib/node_modules/bcoin');
      assert(bcoin);

      const node = new bcoin.FullNode({
        prefix: '#{testpath}/.bcoin',
        memory: false
      });
      (async () => {
        await node.ensure();
      })();
    EOS
    system "#{node.opt_bin}/node", testpath/"script.js"
    assert File.directory?("#{testpath}/.bcoin")
  end
end
