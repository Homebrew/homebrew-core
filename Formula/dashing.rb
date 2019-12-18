class Dashing < Formula
  desc "Generate Dash documentation from HTML files"
  homepage "https://github.com/technosophos/dashing"
  url "https://github.com/technosophos/dashing/archive/0.4.0.tar.gz"
  sha256 "81b21acae83c144f10d9eea05a0b89f0dcdfa694c3760c2a25bd4eab72a2a3b9"

  bottle do
    cellar :any_skip_relocation
    sha256 "bb2b2cd4af4b6ac109bd7d8df6fdac88e901357c9f7acca90bb44314155e3bf1" => :mojave
    sha256 "8977385e74741b7e014e971a320f58c360eede59f68894f1539040b5af474a25" => :high_sierra
    sha256 "09fb6574fe2cf30bb94197730b7e6d3117929607a571e42058a40a5e7b500e70" => :sierra
    sha256 "b37d425623bdbb32fe99d58c6d15cbc0753706aad3758aaf95ed229316e2a185" => :el_capitan
  end

  depends_on "go" => :build

  # Use ruby docs just as dummy documentation to test with
  resource "ruby_docs_tarball" do
    url "https://ruby-doc.com/downloads/ruby_2_6_5_core_rdocs.tgz"
    sha256 "1ef2923161031789a88ac40630c93b7c4feb74147b47fd14c0dfe53559dc6622"
  end

  def install
    (buildpath/"src/github.com/technosophos/dashing").install buildpath.children
    cd "src/github.com/technosophos/dashing" do
      system "go", "build", "-o", bin/"dashing", "-ldflags",
             "-X main.version=#{version}"
      prefix.install_metafiles
    end
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
