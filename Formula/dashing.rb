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

  resource "ruby_docs_tarball" do
    url "http://ruby-doc.com/downloads/ruby_2_6_5_core_rdocs.tgz"
    sha256 "f9f74cf85c84e934d7127c2e86f4c3b0b70380a92c400decdc8a77ac977097fe"
  end

  def install
    system "go", "build", "-o", bin/"dashing", "-ldflags",
             "-X main.version=#{version}"
    prefix.install_metafiles
  end

  test do
    # Make sure that dashing creates its settings file and then builds an actual
    # docset for Dash
    testpath.install resource("ruby_docs_tarball")
    system bin/"dashing", "create"
    assert_predicate testpath/"dashing.json", :exist?
    system bin/"dashing", "build", "."
    file = testpath/"dashing.docset/Contents/Resources/Documents/goruby_c.html"
    assert_predicate file, :exist?
  end
end
