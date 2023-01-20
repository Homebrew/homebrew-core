require "language/node"

class Pandemics < Formula
  desc "Converts your markdown document in a simplified framework"
  homepage "https://pandemics.gitlab.io"
  url "https://registry.npmjs.org/pandemics/-/pandemics-0.11.11.tgz"
  sha256 "e9e54497f5b32c15cb5635d780566d855d086b82c352be154d5fb01a18f8ff7e"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d067a0bb598178d1d774015aaa93d8ad21d021501541a78c005afe8f19da109"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9363a6ce01d8d91fa2eec4d3956589b599b6c72405f1b130736977c037e1f8bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9363a6ce01d8d91fa2eec4d3956589b599b6c72405f1b130736977c037e1f8bd"
    sha256 cellar: :any_skip_relocation, monterey:       "1fa20d0ac8a7faa555023482cc4387c9caa07a39b99149517ea24ae2683b2a2e"
    sha256 cellar: :any_skip_relocation, big_sur:        "1fa20d0ac8a7faa555023482cc4387c9caa07a39b99149517ea24ae2683b2a2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9363a6ce01d8d91fa2eec4d3956589b599b6c72405f1b130736977c037e1f8bd"
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
