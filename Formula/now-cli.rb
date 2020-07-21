require "language/node"

class NowCli < Formula
  desc "The command-line interface for Now"
  homepage "https://zeit.co/now"
  url "https://registry.npmjs.org/now/-/now-19.2.0.tgz"
  sha256 "fdd08e1a80dfbc509efae5b2c8155200b834f5d9ea10b692ec8728c05560765c"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "c49b98f73a8bf5ae3c610245f0381f2a04daedb195bedf7a0532d2dec45251f7" => :catalina
    sha256 "89423b70e300153bd7e15c96bee591003afe5ad52f61b6e2dcf7ae390be1e9d8" => :mojave
    sha256 "cc0752628419a385eec62bacb275d13f22342a2f87395ce0263958e9bf1e0226" => :high_sierra
  end

  depends_on "node"

  def install
    rm Dir["dist/{*.exe,xsel}"]
    inreplace "dist/index.js", "t.default=getUpdateCommand",
                               "t.default=async()=>'brew upgrade now-cli'"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/now", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end
