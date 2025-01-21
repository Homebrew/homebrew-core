class Pandemics < Formula
  desc "Converts your markdown document in a simplified framework"
  homepage "https://pandemics.gitlab.io"
  url "https://registry.npmjs.org/pandemics/-/pandemics-0.12.1.tgz"
  sha256 "9be418ec78ca512cc66d57a7533a5acda003c8bc488d7fff7fa2905c9ad39e29"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "445777877cbca7a8c5e0c8096b16948aa2b93c2a5ae41b71cb75e660ba2710d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ba38e44b4f4b7d27ff08bb11cfc4d0ff0c3acc0643748668cdd9cca3e015f365"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba38e44b4f4b7d27ff08bb11cfc4d0ff0c3acc0643748668cdd9cca3e015f365"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba38e44b4f4b7d27ff08bb11cfc4d0ff0c3acc0643748668cdd9cca3e015f365"
    sha256 cellar: :any_skip_relocation, sonoma:         "a759108afc20634004c21dde25897cf10004a275c33706af36f4c6a2e19bbaf0"
    sha256 cellar: :any_skip_relocation, ventura:        "a759108afc20634004c21dde25897cf10004a275c33706af36f4c6a2e19bbaf0"
    sha256 cellar: :any_skip_relocation, monterey:       "a759108afc20634004c21dde25897cf10004a275c33706af36f4c6a2e19bbaf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c286b0bc6887c50d894e25699b0e312a2663b40e5d8c44dbc73501cca334d8e4"
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
    assert_predicate testpath/"pandemics/test.html", :exist?
  end
end
