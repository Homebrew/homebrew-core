require "language/node"

class NowCli < Formula
  desc "The command-line interface for Now"
  homepage "https://zeit.co/now"
  url "https://registry.npmjs.org/now/-/now-16.3.1.tgz"
  sha256 "5871a4ddd57c91adab7976cc7ac8a434b117ca5f98c9c601cbeccd2a80efa190"

  bottle do
    cellar :any_skip_relocation
    sha256 "808623bd8ab2afdcc4f84125a2812020a03891ca94098da604517f069805534b" => :catalina
    sha256 "067d7c34a0d14f648cbb0a055572b86b0570a048caf76f285b0454f571b623b8" => :mojave
    sha256 "f93e8ad8e3dbf2c3fb880fb92a390c4d8dd5b325c7157671d0107e669334e6d3" => :high_sierra
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
