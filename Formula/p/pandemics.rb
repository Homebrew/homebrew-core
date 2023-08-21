require "language/node"

class Pandemics < Formula
  desc "Converts your markdown document in a simplified framework"
  homepage "https://pandemics.gitlab.io"
  url "https://registry.npmjs.org/pandemics/-/pandemics-0.11.11.tgz"
  sha256 "e9e54497f5b32c15cb5635d780566d855d086b82c352be154d5fb01a18f8ff7e"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ba3d95dc31bec61a6be96c0a0ee08befebf159f2d92c3f900bf5c6d29f7959e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ba3d95dc31bec61a6be96c0a0ee08befebf159f2d92c3f900bf5c6d29f7959e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3ba3d95dc31bec61a6be96c0a0ee08befebf159f2d92c3f900bf5c6d29f7959e"
    sha256 cellar: :any_skip_relocation, ventura:        "fcb7becebfe11194903b3c2f602a3e20840c6fccc9e2482cba6672acf630cbe8"
    sha256 cellar: :any_skip_relocation, monterey:       "fcb7becebfe11194903b3c2f602a3e20840c6fccc9e2482cba6672acf630cbe8"
    sha256 cellar: :any_skip_relocation, big_sur:        "fcb7becebfe11194903b3c2f602a3e20840c6fccc9e2482cba6672acf630cbe8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ba3d95dc31bec61a6be96c0a0ee08befebf159f2d92c3f900bf5c6d29f7959e"
  end

  depends_on "librsvg"
  depends_on "node"
  depends_on "pandoc"
  depends_on "pandoc-crossref"

  def install
    ENV["PANDEMICS_DEPS"]="0"
    # npm ignores config and ENV when in global mode so:
    # - install without running the package install script
    system "npm", "install", "--ignore-scripts", *Language::Node.std_npm_install_args(libexec)
    # - call install script manually to ensure ENV is respected
    system "npm", "run", "--prefix", "#{libexec}/lib/node_modules/pandemics", "install"
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    # version is correct?
    assert_equal version, shell_output("#{libexec}/bin/pandemics --version")
    # does compile to pdf?
    touch testpath/"test.md"
    system "#{bin}/pandemics", "publish", "--format", "html", "#{testpath}/test.md"
    assert_predicate testpath/"pandemics/test.html", :exist?
  end
end
