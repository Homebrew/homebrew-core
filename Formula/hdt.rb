class Hdt < Formula
  desc "Header Dictionary Triples (HDT) is a compression format for RDF data"
  homepage "https://github.com/rdfhdt/hdt-cpp"
  url "http://srvgal80.deri.ie/~pabtor/hdt/hdt-1.3.3.tar.gz"
  sha256 "ac624802909ce04cbc046f00173496fb44768b45157d284d258d394477ae23b9"

  depends_on "pkg-config" => :build
  depends_on "serd"

  uses_from_macos "zlib"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/rdf2hdt", "-h"
    path = testpath/"test.nt"
    path.write <<~EOS
      <http://example.org/uri1> <http://example.org/predicate1> "literal1" .
      <http://example.org/uri1> <http://example.org/predicate1> "literalA" .
      <http://example.org/uri1> <http://example.org/predicate1> "literalA" .
      <http://example.org/uri1> <http://example.org/predicate1> "literalB" .
      <http://example.org/uri1> <http://example.org/predicate1> "literalC" .
      <http://example.org/uri1> <http://example.org/predicate2> <http://example.org/uri3> .
      <http://example.org/uri1> <http://example.org/predicate2> <http://example.org/uriA3> .
      <http://example.org/uri1> <http://example.org/predicate2> <http://example.org/uriA3> .
      <http://example.org/uri2> <http://example.org/predicate1> "literal1" .
      <http://example.org/uri3> <http://example.org/predicate3> <http://example.org/uri4> .
      <http://example.org/uri3> <http://example.org/predicate3> <http://example.org/uri5> .
      <http://example.org/uri4> <http://example.org/predicate4> <http://example.org/uri5> .
    EOS
    system "#{bin}/rdf2hdt", path, "test.hdt"
    assert_predicate testpath/"test.hdt", :exist?
    system "#{bin}/hdtInfo", "test.hdt"
  end
end
