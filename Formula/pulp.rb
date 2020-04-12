require "language/node"

class Pulp < Formula
  desc "Build tool for PureScript projects"
  homepage "https://github.com/bodil/pulp"
  url "https://registry.npmjs.org/pulp/-/pulp-14.0.0.tgz"
  sha256 "ab4d1a669b7ff7d4cd6c4473251a516f310473fcded3c4ee04547865957c1e67"

  bottle do
    cellar :any_skip_relocation
    sha256 "bec16642f812372fa5260f59250a72c13ef363c01ab6aaba1eb5997e27d387df" => :catalina
    sha256 "d5380db101369a8a71a6e64badd0a30419907a4bba22b0400e8add077dcdaa7b" => :mojave
    sha256 "e3fc10ded86c2d8ec89efb373ad8af6994ff800904a7808a73b994c42a273dce" => :high_sierra
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
