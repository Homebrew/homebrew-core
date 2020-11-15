require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-1.2.4.tgz"
  sha256 "fc093e28c733e8c8789475bac8a79daff8d6af3d4b92be8ffe56ef58ae2888b8"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "3680f6f9e41d62a6672a8cb1f98e20677443dd55543e7115543ac586f43353b6" => :catalina
    sha256 "7642c533dac3f98894f8c1a6b4ba391900d552c0d2e9a75771a1b64b3cbf43df" => :mojave
    sha256 "f1531c2c00a3e9eb958016b3f6664bd9d608f6864ddb401d886c3359846196a1" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "<p>hello <em>world</em></p>", pipe_output("#{bin}/marked", "hello *world*").strip
  end
end
