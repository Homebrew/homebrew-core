class Bcoin < Formula
  desc "Javascript bitcoin library for node.js and browsers"
  homepage "https://bcoin.io"
  url "https://github.com/bcoin-org/bcoin/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "fa1a78a73bef5837b7ff10d18ffdb47c0e42ad068512987037a01e8fad980432"
  license "MIT"
  head "https://github.com/bcoin-org/bcoin.git", branch: "master"

  bottle do
    rebuild 3
    sha256                               arm64_tahoe:    "22cb74e6bd2ddf842240be2209f1412af7423eb335056fdc7a58616d2a9dd4aa"
    sha256                               arm64_sequoia:  "bcd872395d69686c004555e77f78998ca1a01e4d1a0f0d4f6315e5cc0a112be2"
    sha256                               arm64_sonoma:   "c357454a7b33d7fe78ddad3a974eeb031642d8f82a49ad633c036d9a26657dcd"
    sha256                               arm64_ventura:  "95e36e42caef34098e5802e9e8ede2cfa9b11c348eef528087ead3a1846647f9"
    sha256                               arm64_monterey: "2fccc2d7ac70da7276f1b951913b0f4d85ecc5990f35a0b790a9a496d432c84a"
    sha256                               sonoma:         "48ca919ef8d01a8332ed7ce0b86d8ec413a507eecc59b7ca57d28b90202bdc1e"
    sha256                               ventura:        "4ad6a6a70e1ae53934f27d45aecabf79139a8cc9b007613e15d87301c80bb3b0"
    sha256                               monterey:       "8f094aa7df3a4ee4fba05e5da0fc690b8f15e01515d5c31135d3d0f2267fd150"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "ece62525442c20293c56edcffd663feb78c8a5cba539a970e06604af2ac1385d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf6e4646d6f73fd463fe22799476324f382b7f86fe1bfcb1991ea930bcff5d56"
  end

  depends_on "node"

  uses_from_macos "python" => :build

  def node
    deps.reject(&:build?)
        .map(&:to_formula)
        .find { |f| f.name.match?(/^node(@\d+(\.\d+)*)?$/) }
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"script.js").write <<~JS
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
    JS
    system "#{node.opt_bin}/node", testpath/"script.js"
    assert File.directory?("#{testpath}/.bcoin")
  end
end
