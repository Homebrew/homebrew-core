require "language/node"

class Pandemics < Formula
  desc "Converts your markdown document in a simplified framework"
  homepage "https://pandemics.gitlab.io"
  url "https://registry.npmjs.org/pandemics/-/pandemics-0.12.1.tgz"
  sha256 "9be418ec78ca512cc66d57a7533a5acda003c8bc488d7fff7fa2905c9ad39e29"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e903551f020b611f22d074a0c0c9d57ecfc474755cd8265c09847e86778f0bd1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e903551f020b611f22d074a0c0c9d57ecfc474755cd8265c09847e86778f0bd1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e903551f020b611f22d074a0c0c9d57ecfc474755cd8265c09847e86778f0bd1"
    sha256 cellar: :any_skip_relocation, sonoma:         "3f9f657ee8034b2a8f061362e8eb9a74019dc990f54fdb3d75e87c4642857155"
    sha256 cellar: :any_skip_relocation, ventura:        "3f9f657ee8034b2a8f061362e8eb9a74019dc990f54fdb3d75e87c4642857155"
    sha256 cellar: :any_skip_relocation, monterey:       "a0e63b2bcee0890cf82a0dcf37eec467dc860dbdc1ec807c24aa4e44f907f725"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e903551f020b611f22d074a0c0c9d57ecfc474755cd8265c09847e86778f0bd1"
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
