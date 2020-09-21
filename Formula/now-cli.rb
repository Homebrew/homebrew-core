require "language/node"

class NowCli < Formula
  desc "Command-line interface for Now"
  homepage "https://zeit.co/now"
  url "https://registry.npmjs.org/now/-/now-20.1.1.tgz"
  sha256 "fb7ab4055279dc5a376364988a656c5f229fe3a44fbc29ea89ad71f5dcf67ae9"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a33ec53e45f2ef38fe23a0a2e66205783c4e9d6a037d4b5de38bac3b8a1448e8" => :catalina
    sha256 "831da3bb99d51a4a0e566bc7f0494dda30be6b8f16170f97afc36a51c843eda7" => :mojave
    sha256 "a52be7278a1492daa225ecd47b7326f41f60ea2070397903bc3ef09f7f6aec1a" => :high_sierra
  end

  depends_on "node"

  disable! date: "2021-01-31", because: :unmaintained

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
