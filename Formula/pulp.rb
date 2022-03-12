require "language/node"

class Pulp < Formula
  desc "Build tool for PureScript projects"
  homepage "https://github.com/bodil/pulp"
  url "https://registry.npmjs.org/pulp/-/pulp-16.0.0-0.tgz"
  sha256 "77b8a5ff21291257766f54289dbe92d2558fc64e9a034513647a76400c0e7d94"
  license "LGPL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c2b46cd6552c65509f86882217f616c80344e5e53a2f22866c958da790694762"
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
