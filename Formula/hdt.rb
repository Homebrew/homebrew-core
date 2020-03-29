class Hdt < Formula
  desc "Header Dictionary Triples (HDT) is a compression format for RDF data"
  homepage "https://github.com/rdfhdt/hdt-cpp"
  url "http://srvgal80.deri.ie/~pabtor/hdt/hdt-1.3.3.tar.gz"
  sha256 "ac624802909ce04cbc046f00173496fb44768b45157d284d258d394477ae23b9"

  bottle do
    cellar :any
    sha256 "66978658e51117e228dea28a0d4264cfe3ce9ed7e4536eb0726d8c1438d4fb59" => :catalina
    sha256 "333a1baf863f372e94a40474a799fdd7e043bd691817ab5f7467983ce31a21cb" => :mojave
    sha256 "709ea815a3a24e104b0bd873948d8cbaca317ed235098f1c042ab308f7c3cb6f" => :high_sierra
  end

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
