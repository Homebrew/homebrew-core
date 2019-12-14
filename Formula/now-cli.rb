require "language/node"

class NowCli < Formula
  desc "The command-line interface for Now"
  homepage "https://zeit.co/now"
  url "https://registry.npmjs.org/now/-/now-16.7.0.tgz"
  sha256 "40c0120ab663fc04d1438661c853aba901466fbf9d175a2dfa1830da76446212"

  bottle do
    cellar :any_skip_relocation
    sha256 "af49bd7c9f1671857a709fd16c4bc4bb07c99d701a3ad25f7e10d2d7844529e0" => :catalina
    sha256 "31eb408f0c12e28381c5face0f2422949f32757c287ac13316cf1bb4b8583bcb" => :mojave
    sha256 "e7f19917a274d7043b77e4832484caa14a5ce88efddbb1bc0e27857346a84585" => :high_sierra
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
