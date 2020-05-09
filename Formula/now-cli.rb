require "language/node"

class NowCli < Formula
  desc "The command-line interface for Now"
  homepage "https://zeit.co/now"
  url "https://registry.npmjs.org/now/-/now-19.0.0.tgz"
  sha256 "d3290b780b6dd0c2f6eb6d6e807cb7c747aba5fc00349390551900b2c71ab497"

  bottle do
    cellar :any_skip_relocation
    sha256 "13b98b4fb98b0ef2871ce94a580b4d4072a1fcde87297dd3fe926a850776505f" => :catalina
    sha256 "97c8632f75cf1fef197a9101c640845c2231a11919d98408236afa03777906a6" => :mojave
    sha256 "f8bde54f4ad1c45ef2c942d7f580ed539b5de33fdaaf8f356e056255c82cd766" => :high_sierra
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
