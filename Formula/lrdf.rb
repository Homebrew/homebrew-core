class Lrdf < Formula
  desc "RDF library for accessing plugin metadata in the LADSPA plugin system"
  homepage "https://github.com/swh/LRDF"
  url "https://github.com/swh/LRDF/archive/v0.6.1.tar.gz"
  sha256 "d579417c477ac3635844cd1b94f273ee2529a8c3b6b21f9b09d15f462b89b1ef"

  bottle do
    cellar :any
    sha256 "1940f0eb408453bc179cc15c2588ad90eedeef608ec830a10881faee75c00d87" => :mojave
    sha256 "e15d0f6129cd4ba502860f0ab0367eceadf2a377be9dd25af30c52ebffd064c6" => :high_sierra
    sha256 "27f0d95eed42b70eb6685ffe8608465b0f39b88b544dbee080fe3decf81512ed" => :sierra
    sha256 "f615e775140216eff74cd0fe751ace5993030c00921574da635a44b41d8bba57" => :el_capitan
    sha256 "053602eb98310d03ea0ba7838cd0f746dd34a60759a35fcbae7c41ca08a2919f" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "raptor"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    (pkgshare/"examples").install Dir["examples/*"] - Dir["examples/Makefile*"]
  end

  test do
    cp_r pkgshare/"examples/.", testpath
    system ENV.cc, "add_test.c", "-o", "test", "-I#{include}",
                   "-I#{Formula["raptor"].opt_include}/raptor2",
                   "-L#{lib}", "-llrdf"
    system "./test"
    assert_match "<test:id2> <test:foo> \"4\"", File.read("test-out.n3")
  end
end
