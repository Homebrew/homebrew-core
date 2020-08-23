require "language/node"

class Pulp < Formula
  desc "Build tool for PureScript projects"
  homepage "https://github.com/bodil/pulp"
  url "https://registry.npmjs.org/pulp/-/pulp-15.0.0.tgz"
  sha256 "695da1581389d060810ed1a5962ab7e53696db8493b224fa7dc2358f255b8b53"
  license "LGPL-3.0"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b8171d3e267d32cb7c785ee72fb8a1dbe96d7a66a7d5311a23b314a0e742156c" => :catalina
    sha256 "9ee409ce24c46c02db3dade7b2942d8990708de840e03e0a80d5f2498a9bc46e" => :mojave
    sha256 "56016abc98b66356ad0d58c0ea951de4da772abca1f12fd2c3635a7700e36c63" => :high_sierra
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

    system("#{bin}/pulp", "init")
    assert_predicate testpath/".gitignore", :exist?
    assert_predicate testpath/"bower.json", :exist?
  end
end
