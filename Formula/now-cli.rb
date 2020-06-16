require "language/node"

class NowCli < Formula
  desc "The command-line interface for Now"
  homepage "https://zeit.co/now"
  url "https://registry.npmjs.org/now/-/now-19.1.1.tgz"
  sha256 "759fdc112d130750fc47ce7ba0fc39fa631349dfcbdb6b97a10c0bd355f82d69"

  bottle do
    cellar :any_skip_relocation
    sha256 "f045dd5ee06a7ee1b0a83cd80f98155fef00b141255fc2febdb063af386e410d" => :catalina
    sha256 "85e008183c38f7e5348fbf00f82e61f3de14507d069211201d01b7397226b8e5" => :mojave
    sha256 "a8490e66c98c7810b670d737dbac64cf8e64b17fa8ea30a4fb5a277ef82cd8ae" => :high_sierra
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
