require "language/node"

class NowCli < Formula
  desc "The command-line interface for Now"
  homepage "https://zeit.co/now"
  url "https://registry.npmjs.org/now/-/now-20.0.0.tgz"
  sha256 "471d4fb8507b64d1caefa5a5a1433432ccf26b1a2965d9c47e88da3934320b96"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "3f66497bf1bc30dd257998e5a6859d850dba71986bc026e76a2c61b4e5b89065" => :catalina
    sha256 "0d609d774ea44614a3d3125ceb22cbcc076ff08522c40fe873c2cb66cb79700c" => :mojave
    sha256 "a8b67da09daa8152a8cc9eb74ef0cc4efdc5955923a8918128ef98e01c9cd143" => :high_sierra
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
