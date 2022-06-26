class Dashing < Formula
  desc "Generate Dash documentation from HTML files"
  homepage "https://github.com/technosophos/dashing"
  url "https://github.com/technosophos/dashing/archive/0.4.0.tar.gz"
  sha256 "81b21acae83c144f10d9eea05a0b89f0dcdfa694c3760c2a25bd4eab72a2a3b9"
  license "MIT"
  revision 1

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_monterey: "068ec0d62e2f599509d34a2d366895dce2464eaa9aa1939a553dd1e31c8238d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "72b9d5ea8aaf171f9a46e099f190a9adf9ad90b6bd90dcdc54eaa922e2c277f9"
    sha256 cellar: :any_skip_relocation, monterey:       "a0c325204c959b5956248606f6b7fcb4437c6dfa2c75f739d4624fb912ecaa55"
    sha256 cellar: :any_skip_relocation, big_sur:        "7297bb9c8b50feeda73af51b59acfcac18f9d2beb57738de293146aaca7cd089"
    sha256 cellar: :any_skip_relocation, catalina:       "43702cf1fbdeb449e9205716635cba4c62449e575f9a6ab45eeb4aeb166fdf9a"
    sha256 cellar: :any_skip_relocation, mojave:         "bbd3a7995a6b5a0a87f4a08a4e4bb52fe75990bdde6b63bea1a9c56c7c144165"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "982d82dc58980aa81fadf686557c5c075ddb95b9ef0f8456e7b32b6ed49aa382"
  end

  depends_on "go" => :build

  resource "redux_saga_docs_tarball" do
    url "https://github.com/dmitrytut/redux-saga-docset/archive/7df9e3070934c0f4b92d66d2165312bf78ecd6a0.tar.gz"
    sha256 "08e5cc1fc0776fd60492ae90961031b1419ea6ed02e2c2d9db2ede67d9d67852"
  end

  def install
    system "go", "build", "-o", bin/"dashing", "-ldflags",
             "-X main.version=#{version}"
    prefix.install_metafiles
  end

  test do
    # Make sure that dashing creates its settings file and then builds an actual
    # docset for Dash
    testpath.install resource("redux_saga_docs_tarball")
    innerpath = testpath
    system bin/"dashing", "create"
    assert_predicate innerpath/"dashing.json", :exist?
    system bin/"dashing", "build", "."
    innerpath /= "dashing.docset/Contents"
    assert_predicate innerpath/"Info.plist", :exist?
    innerpath /= "Resources"
    assert_predicate innerpath/"docSet.dsidx", :exist?
    innerpath /= "Documents"
    assert_predicate innerpath/"README.md", :exist?
    innerpath /= "docs"
    assert_predicate innerpath/"index.html", :exist?
    innerpath /= "introduction"
    assert_predicate innerpath/"SagaBackground.html", :exist?
  end
end
