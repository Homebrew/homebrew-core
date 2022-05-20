require "language/node"

class Pulp < Formula
  desc "Build tool for PureScript projects"
  homepage "https://github.com/purescript-contrib/pulp"
  url "https://registry.npmjs.org/pulp/-/pulp-16.0.1.tgz"
  sha256 "d62a6667429228f09f1a82fae53e06ac0fdf35deab105cb1ee40fc44fe1f582e"
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
