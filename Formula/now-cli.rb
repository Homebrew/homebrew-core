require "language/node"

class NowCli < Formula
  desc "The command-line interface for Now"
  homepage "https://zeit.co/now"
  url "https://registry.npmjs.org/now/-/now-16.4.0.tgz"
  sha256 "5ae1fc2efdf01b40024d206645d3cbeaeb0562ac6082c04a6106d5a4447ab0b2"

  bottle do
    cellar :any_skip_relocation
    sha256 "497653051d08d061f2968c07cbe402f88acb78cb2c50889493ab54c4a3f48717" => :catalina
    sha256 "713d99c6d946687c2fc7db1bffdeb2ff17eff5400fd8eb93c943f0e5e7722353" => :mojave
    sha256 "e9fced8f9b8ed4ab3cf6c722e8fa7af880e106b20c3da05fecf8c6799384306d" => :high_sierra
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
