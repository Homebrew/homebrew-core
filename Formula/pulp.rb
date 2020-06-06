require "language/node"

class Pulp < Formula
  desc "Build tool for PureScript projects"
  homepage "https://github.com/bodil/pulp"
  url "https://registry.npmjs.org/pulp/-/pulp-15.0.0.tgz"
  sha256 "695da1581389d060810ed1a5962ab7e53696db8493b224fa7dc2358f255b8b53"

  bottle do
    cellar :any_skip_relocation
    sha256 "92e4348d79d02c037b00973449d383678acc9b186b0949ca326f3663306e11f1" => :catalina
    sha256 "46186bc8b38d9a0c877b566b3e4a8af1495189deb546bf40a90613f8696f66ab" => :mojave
    sha256 "68837e60c915d0d22619172eea9e490fb6437d8842d5ea563e8e4d6f40cf77f9" => :high_sierra
  end

  depends_on "bower"
  depends_on "node"
  depends_on "purescript"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pulp --version")

    system("#{bin}/pulp init")
    assert_predicate testpath/".gitignore", :exist?
    assert_predicate testpath/"bower.json", :exist?
  end
end
