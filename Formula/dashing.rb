class Dashing < Formula
  desc "Generate Dash documentation from HTML files"
  homepage "https://github.com/technosophos/dashing"
  url "https://github.com/technosophos/dashing/archive/0.4.0.tar.gz"
  sha256 "81b21acae83c144f10d9eea05a0b89f0dcdfa694c3760c2a25bd4eab72a2a3b9"
  license "MIT"
  revision 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "0d163c87983480a05462f6e85967795b2f7d276163a4e4f34c8ff3411bcc39c2" => :catalina
    sha256 "2990466bfb888e22f2dee7b4521aa022e693176c0fdb4f5c8731a46084fa48c2" => :mojave
    sha256 "d2aedd54300f6590a10ee654fbe406be903a7a08e68f275bc0868e12b5a6f45f" => :high_sierra
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
