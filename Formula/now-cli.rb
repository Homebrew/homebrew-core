require "language/node"

class NowCli < Formula
  desc "The command-line interface for Now"
  homepage "https://zeit.co/now"
  url "https://registry.npmjs.org/now/-/now-16.7.1.tgz"
  sha256 "b29b6f107bfe883d0974f80711daf48e627b9130ae4adb227f925902487dae66"

  bottle do
    cellar :any_skip_relocation
    sha256 "56f5e1c4da10c17a05a3d95cf3355e750eccb1a8e4acb538067afa4cdb985998" => :catalina
    sha256 "093a9219a99272f78e3068be5ed90aafd20b4c89ad2030a605f26c06dcfab8b9" => :mojave
    sha256 "4865598ed44ccfe292a229302aa21541c3af0140701f315a79c42714081cf1ba" => :high_sierra
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
