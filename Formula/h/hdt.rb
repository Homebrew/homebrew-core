class Hdt < Formula
  desc "Header Dictionary Triples (HDT) is a compression format for RDF data"
  homepage "https://github.com/rdfhdt/hdt-cpp"
  url "https://github.com/rdfhdt/hdt-cpp/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "3abc8af7a0b19760654acf149f0ec85d4e9589a32c4331d3bfbe2fcd825173e6"
  license "LGPL-2.1-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "46d5822d2e9fe086b04b5e0f698e8fbbc6235da2f5a95987ac71479b6c2b232a"
    sha256 cellar: :any,                 arm64_sequoia: "ae9bd2a9b1e243004fac4cd8f28b283efb97c13700de34d16818e68f3abf5b64"
    sha256 cellar: :any,                 arm64_sonoma:  "4c49e3c9f860c27ffb56c2b3bd7b0e5e187c57e5207c2eaf88ed934ec812efcc"
    sha256 cellar: :any,                 sonoma:        "557a38517d6af2dc25f191758a590acae074f7c0d549c49cdf2af3781f6d6ae4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "142304a83cb7d18dab6b9f8b56791f9148d15a9e30641fb21d54553f12e10b28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44f1d786ef6d43ec1e4daca46268d2e57d1855985fd06871bb78c4c0228f5e89"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "serd"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
