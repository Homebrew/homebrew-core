require "language/node"

class Pulp < Formula
  desc "Build tool for PureScript projects"
  homepage "https://github.com/bodil/pulp"
  url "https://registry.npmjs.org/pulp/-/pulp-15.0.0.tgz"
  sha256 "695da1581389d060810ed1a5962ab7e53696db8493b224fa7dc2358f255b8b53"

  bottle do
    cellar :any_skip_relocation
    sha256 "8e7aaa1a3e6fc065162b2e535ade71a587c2d8151bd82074ccd4dd36b7aca8cb" => :catalina
    sha256 "2bf17078a2d30193705626eb8fb8d6dfc936effc6db765cdd3b4ebc7303646d2" => :mojave
    sha256 "d416ae4cefb7f3b3efd1120927e0286d4384f1bfb5f98317fece4648ace1f6be" => :high_sierra
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
