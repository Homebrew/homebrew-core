class Dashing < Formula
  desc "Generate Dash documentation from HTML files"
  homepage "https://github.com/technosophos/dashing"
  url "https://github.com/technosophos/dashing/archive/0.4.0.tar.gz"
  sha256 "81b21acae83c144f10d9eea05a0b89f0dcdfa694c3760c2a25bd4eab72a2a3b9"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "cdfb4329ae48807046deb40bb2adb9969afda47a25502cedb374cf21a6a605ee" => :catalina
    sha256 "79874bca8f27064c16aa81b398131d7ed3558bd5987913e344d0075859d9f7c7" => :mojave
    sha256 "8c34e42f44271bfea4aecbb5dedb18deecfc4b8d0d0564344efa861bb816e8d4" => :high_sierra
  end

  depends_on "go" => :build

  # Use ruby docs just as dummy documentation to test with
  resource "ruby_docs_tarball" do
    url "https://ruby-doc.com/downloads/ruby_2_6_5_core_rdocs.tgz"
    sha256 "9b5fc2814e4ce33701b3f6614a3309b8ed7a229e8b9b87cc5e75d5d4dbda1e12"
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
