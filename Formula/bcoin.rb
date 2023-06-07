require "language/node"

class Bcoin < Formula
  desc "Javascript bitcoin library for node.js and browsers"
  homepage "https://bcoin.io"
  url "https://github.com/bcoin-org/bcoin/archive/v2.2.0.tar.gz"
  sha256 "fa1a78a73bef5837b7ff10d18ffdb47c0e42ad068512987037a01e8fad980432"
  license "MIT"
  head "https://github.com/bcoin-org/bcoin.git", branch: "master"

  bottle do
    rebuild 2
    sha256                               arm64_ventura:  "c3c02702652f0f567697cc614212a757d29fb3ee3d80ec9345dc7d00e10dd421"
    sha256                               arm64_monterey: "777aa63316694628e1c88cd4ad73949ac2c32b97aac6d5e196c82d2a0040c13c"
    sha256                               arm64_big_sur:  "304cc113c0dc1dec7d70745e73b816802f4f92068ece45298957ab6feb7edc7c"
    sha256                               ventura:        "746e792b08dd522e81d1440c159997cf231044da8299726eb4ebadb0d497ffe7"
    sha256                               monterey:       "49abdb5b53e076417bc0c0431a8dc6aff1d3030e2e2c90625a273a1545dfc8c9"
    sha256                               big_sur:        "875527a488aec56c22828e1d314097d984d1acacd83f6533203bbd7437a6c027"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43047da636f3b6b7fc3f230f4f55c4805723429531e8c1887ea896b51fcd9a38"
  end

  depends_on "python@3.11" => :build
  depends_on "node"

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
