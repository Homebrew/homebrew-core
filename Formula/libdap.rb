class Libdap < Formula
  desc "Framework for scientific data networking"
  homepage "https://www.opendap.org/"
  url "https://www.opendap.org/pub/source/libdap-3.20.4.tar.gz"
  sha256 "b16812c6ea3b01e5a02a54285af94a7dd57db929a6e92b964d642534f48b8474"
  revision 1

  bottle do
    sha256 "a38c881902d2996093520bf04f7c714a3a71c9f1ec42e06f932b81ce7f206891" => :mojave
    sha256 "2ff6f1c77e10a0983a23e7e07b2258c8ee2204daf03ca626fc525baf570f4aec" => :high_sierra
    sha256 "f5badf20cdb797ed444188cfd71cacc525bf9f18d3be39108045d364a10bd60b" => :sierra
  end

  head do
    url "https://github.com/OPENDAP/libdap4.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "libxml2"
  depends_on "openssl@1.1"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-debug
      --with-included-regex
    ]

    system "autoreconf", "-fvi" if build.head?
    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"

    # Ensure no Cellar versioning of libxml2 path in dap-config entries
    xml2 = Formula["libxml2"]
    inreplace bin/"dap-config", xml2.opt_prefix.realpath, xml2.opt_prefix
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dap-config --version")
  end
end
