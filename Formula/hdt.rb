class Hdt < Formula
  desc "Header Dictionary Triples (HDT) is a compression format for RDF data"
  homepage "https://github.com/rdfhdt/hdt-cpp"
  url "https://github.com/rdfhdt/hdt-cpp/archive/v1.3.3.tar.gz"
  sha256 "3abc8af7a0b19760654acf149f0ec85d4e9589a32c4331d3bfbe2fcd825173e6"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "13a72094b82ac91fe1bbaed2cfb12ffda92903715e105c1136e42c7a1a3d48d0"
    sha256 cellar: :any,                 arm64_big_sur:  "934a8c000b23ee6a63cda409118c47737d4549a5f0fd260a1652ecfc6b49f1d2"
    sha256 cellar: :any,                 monterey:       "693a2273358dcdc130f4bdc102d23e0c7d33d709a417811e737320faf96caaa4"
    sha256 cellar: :any,                 big_sur:        "614cded2abf67c909f7fd1a980b3093e8368bf0fc802adcd774716e9e301f4f9"
    sha256 cellar: :any,                 catalina:       "66978658e51117e228dea28a0d4264cfe3ce9ed7e4536eb0726d8c1438d4fb59"
    sha256 cellar: :any,                 mojave:         "333a1baf863f372e94a40474a799fdd7e043bd691817ab5f7467983ce31a21cb"
    sha256 cellar: :any,                 high_sierra:    "709ea815a3a24e104b0bd873948d8cbaca317ed235098f1c042ab308f7c3cb6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e252bf5067fa866d9fb2d81f5af2fc302347982ed6b8c5c7f1474da27eafff8"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "serd"

  uses_from_macos "zlib"

  def install
    system "./autogen.sh"
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
