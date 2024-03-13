require "language/node"

class Pandemics < Formula
  desc "Converts your markdown document in a simplified framework"
  homepage "https://pandemics.gitlab.io"
  url "https://registry.npmjs.org/pandemics/-/pandemics-0.12.0.tgz"
  sha256 "8106ae09462a19768b4e74cb0079093b73d30ed9bc6ec22e0dd9d4434d23ea3f"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2c8e1c71e10d1599ce608f8bdb8c03b9649d3f3b3e39e6060dae19a5a7cc2581"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c8e1c71e10d1599ce608f8bdb8c03b9649d3f3b3e39e6060dae19a5a7cc2581"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c8e1c71e10d1599ce608f8bdb8c03b9649d3f3b3e39e6060dae19a5a7cc2581"
    sha256 cellar: :any_skip_relocation, sonoma:         "e67ac2267b5cd23b60aebe99d0323fe8816824933d494c14a02b7ad1c4e39452"
    sha256 cellar: :any_skip_relocation, ventura:        "e67ac2267b5cd23b60aebe99d0323fe8816824933d494c14a02b7ad1c4e39452"
    sha256 cellar: :any_skip_relocation, monterey:       "e67ac2267b5cd23b60aebe99d0323fe8816824933d494c14a02b7ad1c4e39452"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c8e1c71e10d1599ce608f8bdb8c03b9649d3f3b3e39e6060dae19a5a7cc2581"
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
