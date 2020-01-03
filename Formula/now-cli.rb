require "language/node"

class NowCli < Formula
  desc "The command-line interface for Now"
  homepage "https://zeit.co/now"
  url "https://registry.npmjs.org/now/-/now-16.7.1.tgz"
  sha256 "b29b6f107bfe883d0974f80711daf48e627b9130ae4adb227f925902487dae66"

  bottle do
    cellar :any_skip_relocation
    sha256 "5341de321390c435512eca186c7d0fecdc245913b8cc950d1ddb7f58f74d15fb" => :catalina
    sha256 "5ea77cc2f2a51e8547b29118a1490e06f884a5130846b5f7b90311d2cdf83227" => :mojave
    sha256 "905283ffb3f177c0711c8b057c683c5b0011a344d79489dfb22f749cbcc3bfbd" => :high_sierra
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
    system "#{bin}/now", "init", "markdown"
    assert_predicate testpath/"markdown/now.json", :exist?, "now.json must exist"
    assert_predicate testpath/"markdown/README.md", :exist?, "README.md must exist"
  end
end
