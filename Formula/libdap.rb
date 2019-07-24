class Libdap < Formula
  desc "Framework for scientific data networking"
  homepage "https://www.opendap.org/"
  url "https://www.opendap.org/pub/source/libdap-3.20.4.tar.gz"
  sha256 "b16812c6ea3b01e5a02a54285af94a7dd57db929a6e92b964d642534f48b8474"

  bottle do
    sha256 "d2f5c13913633acafe8c090b9ff94ad3f9eae5d7699be4707da57f15524fc530" => :mojave
    sha256 "15bf626100714d66c1691db44574295b5f257b1f0e3df025ac3f7c12c2526697" => :high_sierra
    sha256 "ccb2d18958ed0115c1e1294e1c13d1c4afed8090a88efd0a6c6ff023bb697093" => :sierra
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
  depends_on "openssl"

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
