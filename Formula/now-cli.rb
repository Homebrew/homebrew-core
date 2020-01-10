require "language/node"

class NowCli < Formula
  desc "The command-line interface for Now"
  homepage "https://zeit.co/now"
  url "https://registry.npmjs.org/now/-/now-16.7.3.tgz"
  sha256 "f8f918995a6f3f597ee9bdcf5d2330a35c65ac17690d03a12a0b06272f3c3250"

  bottle do
    cellar :any_skip_relocation
    sha256 "1921f11a8f121035ac8227b288d72e43d4d8594ce8f1b5813a3110a1a38e4276" => :catalina
    sha256 "7989018b2565a6d531ac114a79953c870f659d8b0fa7fa464128590e10cbcc38" => :mojave
    sha256 "503a4e0dd73fefa6254253d21813529583f90df460870ae049f79c07e40ccf73" => :high_sierra
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
