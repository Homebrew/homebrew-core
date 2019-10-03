require "language/node"

class NowCli < Formula
  desc "The command-line interface for Now"
  homepage "https://zeit.co/now"
  url "https://registry.npmjs.org/now/-/now-16.3.1.tgz"
  sha256 "5871a4ddd57c91adab7976cc7ac8a434b117ca5f98c9c601cbeccd2a80efa190"

  bottle do
    cellar :any_skip_relocation
    sha256 "594c1ffe061a55809d75fc3c814ac87a23645c1b6f698c36cc49c46205c40807" => :catalina
    sha256 "fa859498b4f65da01efe81b00edc756f32208f79f73f4ccccbea18fc77c0a931" => :mojave
    sha256 "288803c08d192ea9b18467ced1d45be530cd01187fe885b759918318aaae96a3" => :high_sierra
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
