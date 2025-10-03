class Hdt < Formula
  desc "Header Dictionary Triples (HDT) is a compression format for RDF data"
  homepage "https://github.com/rdfhdt/hdt-cpp"
  url "https://github.com/rdfhdt/hdt-cpp/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "3abc8af7a0b19760654acf149f0ec85d4e9589a32c4331d3bfbe2fcd825173e6"
  license "LGPL-2.1-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "669b29ec8ed486008cb630759f7e6b0c60fe3fb4c8a86664fcce126c13c38ca8"
    sha256 cellar: :any,                 arm64_sequoia:  "85d785dfa207bd588ef5e630b9a5adde0d98bac472119547d6128e0544de7bb4"
    sha256 cellar: :any,                 arm64_sonoma:   "606b24419877439b12ba1833394854122acf1342bf10fa6801b32d213e12f1aa"
    sha256 cellar: :any,                 arm64_ventura:  "a68a7b396c8b98c042548bd50ea2fc8736e1588be1c1f0d092bcc9d150df1f32"
    sha256 cellar: :any,                 arm64_monterey: "13a72094b82ac91fe1bbaed2cfb12ffda92903715e105c1136e42c7a1a3d48d0"
    sha256 cellar: :any,                 arm64_big_sur:  "934a8c000b23ee6a63cda409118c47737d4549a5f0fd260a1652ecfc6b49f1d2"
    sha256 cellar: :any,                 sonoma:         "f6ff8a133b9be463e6b3212a5b9c2c2c3a022e369c02caf06eb1b8f0cf8d34c2"
    sha256 cellar: :any,                 ventura:        "a086f2948a08f8143d2d379dad6165689f27904b03937287d2fa3c1d4daf5bca"
    sha256 cellar: :any,                 monterey:       "693a2273358dcdc130f4bdc102d23e0c7d33d709a417811e737320faf96caaa4"
    sha256 cellar: :any,                 big_sur:        "614cded2abf67c909f7fd1a980b3093e8368bf0fc802adcd774716e9e301f4f9"
    sha256 cellar: :any,                 catalina:       "66978658e51117e228dea28a0d4264cfe3ce9ed7e4536eb0726d8c1438d4fb59"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "3fa37020c7bf676a78fd5678b77cf64e48d1a04d71b142f3e6f07360a9582522"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e252bf5067fa866d9fb2d81f5af2fc302347982ed6b8c5c7f1474da27eafff8"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "serd"

  uses_from_macos "zlib"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"rdf2hdt", "-h"

    test_file = testpath/"test.nt"
    test_file.write <<~EOS
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

    system bin/"rdf2hdt", test_file, "test.hdt"
    assert_path_exists testpath/"test.hdt"
    system bin/"hdtInfo", "test.hdt"
  end
end
