require "language/node"

class NowCli < Formula
  desc "The command-line interface for Now"
  homepage "https://zeit.co/now"
  url "https://registry.npmjs.org/now/-/now-16.6.3.tgz"
  sha256 "c06f4b58ffae0a1f5950dd094fde08976eb2bdad1372acf5f0e1e873e455321b"

  bottle do
    cellar :any_skip_relocation
    sha256 "6c2ed9d69ecfe66a04cf85a408adb5c6bbf29e700880518cfe30e7b787e35c3b" => :catalina
    sha256 "9fb7a5a426c153aad231aac1447af7d707b8ab812cb9c5afe873e9cb2da25615" => :mojave
    sha256 "8e32d3bc2263ea0c4fe4a53873710e027ef726c899fc90d045222fe6410e3e9d" => :high_sierra
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
