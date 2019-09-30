require "language/node"

class NowCli < Formula
  desc "The command-line interface for Now"
  homepage "https://zeit.co/now"
  url "https://registry.npmjs.org/now/-/now-16.3.0.tgz"
  sha256 "cbf8f26aea8653c044405d47cb6f5a33be112361a5371730a5aa6662f6f8f6dc"

  bottle do
    cellar :any_skip_relocation
    sha256 "457ef16dba6645113a5d732b7a7f7e7c9b9e9350a215aa9e8fe57cbe255affcd" => :mojave
    sha256 "33f697ab7963497b1c75e98276ba75a9fe90eb3df2612d1aa4435ba1db32bb7c" => :high_sierra
    sha256 "d663d46344af392335d8e6161e75fb837d00af0eb450f35350bd58341ec17304" => :sierra
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
