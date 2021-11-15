require "language/node"

class Bcoin < Formula
  desc "Javascript bitcoin library for node.js and browsers"
  homepage "https://bcoin.io"
  url "https://github.com/bcoin-org/bcoin/archive/v2.2.0.tar.gz"
  sha256 "fa1a78a73bef5837b7ff10d18ffdb47c0e42ad068512987037a01e8fad980432"
  license "MIT"
  head "https://github.com/bcoin-org/bcoin.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "0c4f787a2f63c1db4221a17f1c275f31a2649858c9219deefa65c90484e023e7"
    sha256                               arm64_big_sur:  "f5c6098faf7dba740533388c16d2bcf72e37416d7c5e5bdf6610f67fc85134aa"
    sha256                               monterey:       "d5fd6c1050ff44c36d79496648630c0ff04e8ee3acf45c97069a360267441073"
    sha256                               big_sur:        "593c59f9f3e790c1736093490ac0586d6b46e1672f450d3b8b5b32547c86a951"
    sha256                               catalina:       "3e55360c62032fafb4590bd3b80d6cd2cb84ac49737ec129199417db39dfd6cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac2900d97c5844734f8bb79f41c30d0eb3a482349da8d0c6e1d3542d8a5800ca"
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
