require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.1.3.tgz"
  sha256 "e52d7c88d6af42dccbf9853382038558731bfc76c6bbe9e85d8ac4df63acb3d2"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "271171407956fa777e1424e3dec8dbb5eb26b1809900fecacc7ebaae4653d102" => :big_sur
    sha256 "d580978ab2bbe9ba36ebac0df78d27e290aeb6ece759c505bc6a16a4df79524f" => :arm64_big_sur
    sha256 "348c22c7de910e5ba5014d963884b53cd563a0922ac6a90dba919eaa895a2ea4" => :catalina
    sha256 "63bdb5f27282856586e36ec9a821b35e47239072d67111f8ec3c6b15cd80c3fd" => :mojave
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/netlify login
      expect "Opening"
    EOS
    assert_match "Logging in", shell_output("expect -f test.exp")
  end
end
