require "language/node"

class NowCli < Formula
  desc "The command-line interface for Now"
  homepage "https://zeit.co/now"
  url "https://registry.npmjs.org/now/-/now-19.2.0.tgz"
  sha256 "fdd08e1a80dfbc509efae5b2c8155200b834f5d9ea10b692ec8728c05560765c"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "76ffadc49a7bbc9193af396e96fa7919990dd3d239275d7e0197fa6213d16846" => :catalina
    sha256 "7db0668187100499f9c07dbb25b63304e2d0f2e804800d472db672321c60d9e7" => :mojave
    sha256 "8420752dd1c3e11f72e24454b8949d0194519849305e6bafad058a0b36046e05" => :high_sierra
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
