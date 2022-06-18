require "language/node"

class Pulp < Formula
  desc "Build tool for PureScript projects"
  homepage "https://github.com/purescript-contrib/pulp"
  url "https://registry.npmjs.org/pulp/-/pulp-16.0.2.tgz"
  sha256 "a70585e06c1786492fde10c9c1bc550405351c2e6283bbd3f777a6a04fb462ff"
  license "LGPL-3.0-or-later"

  livecheck do
    url :stable
    regex(%r{href=.*?/package/pulp/v/(\d+(?:[.-]\d+)+)["']}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ca587774d93f4ad417f6b91a951b110999119be5a1b74e487c797afc9c24c751"
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
