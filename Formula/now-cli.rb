require "language/node"

class NowCli < Formula
  desc "The command-line interface for Now"
  homepage "https://zeit.co/now"
  url "https://registry.npmjs.org/now/-/now-16.5.0.tgz"
  sha256 "0c665d7af5b6e4a9b954a3435cf430ccecbfaa8e72084a210c55ed3c28f63a2c"

  bottle do
    cellar :any_skip_relocation
    sha256 "21b8ca2b7d39b05c7b4182f132efb4950a02b3f5aee7b1189fabeef2c22eb911" => :catalina
    sha256 "1a453bf09a84b48a43862be487ce6696c291176822e3347d3f9f69240ad03e9c" => :mojave
    sha256 "b33a49998ca484174e1fd8bd2250578d3fd99ad02dc7bcd22555340ad27e5fea" => :high_sierra
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
