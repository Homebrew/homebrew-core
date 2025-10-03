class Pandemics < Formula
  desc "Converts your markdown document in a simplified framework"
  homepage "https://pandemics.gitlab.io"
  url "https://registry.npmjs.org/pandemics/-/pandemics-0.12.1.tgz"
  sha256 "9be418ec78ca512cc66d57a7533a5acda003c8bc488d7fff7fa2905c9ad39e29"
  license "BSD-3-Clause"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "56f5dfc850d49885e631d590e330b5555985312ec11a483ac8001b3ca9f5be46"
  end

  depends_on "librsvg"
  depends_on "node"
  depends_on "pandoc"
  depends_on "pandoc-crossref"

  def install
    ENV["PANDEMICS_DEPS"]="0"
    # npm ignores config and ENV when in global mode so:
    # - install without running the package install script
    system "npm", "install", "--ignore-scripts", *std_npm_args
    # - call install script manually to ensure ENV is respected
    system "npm", "run", "--prefix", libexec/"lib/node_modules/pandemics", "install"
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    # version is correct?
    assert_equal version, shell_output("#{libexec}/bin/pandemics --version")
    # does compile to pdf?
    touch testpath/"test.md"
    system bin/"pandemics", "publish", "--format", "html", "#{testpath}/test.md"
    assert_path_exists testpath/"pandemics/test.html"
  end
end
