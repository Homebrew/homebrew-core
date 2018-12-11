require "language/node"

class Fx < Formula
  desc "Command-line JSON processing tool"
  homepage "https://github.com/antonmedv/fx"
  url "https://registry.npmjs.org/fx/-/fx-9.0.2.tgz"
  sha256 "79ed78f15df62b3e75956174081bd7696625519da52f14003c70a907471f039d"

  bottle do
    cellar :any_skip_relocation
    sha256 "b901b7c82509b6d7be7543002c49b43b1e4eb49bf11670047e521f016f87651f" => :mojave
    sha256 "7b818ada3439c79515987598a739a12634a61f99eb630090d59a734b071f7c50" => :high_sierra
    sha256 "ac39d58f3c0c2d23c102f9165203f9b3f0f7b52b5d3c1786c10b48c0626c591d" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "bar", shell_output("echo '{\"foo\": \"bar\"}' #{bin}/fx .foo")
  end
end
