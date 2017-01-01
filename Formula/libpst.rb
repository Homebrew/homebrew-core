class Libpst < Formula
  desc "Utilities for the PST file format"
  homepage "http://www.five-ten-sg.com/libpst/"
  url "http://www.five-ten-sg.com/libpst/packages/libpst-0.6.69.tar.gz"
  sha256 "66952669983026cae67ce066d1434aa1c86edbe2cffa2841989bc4374540bfbc"

  bottle do
    cellar :any
    sha256 "485e350554368c75fdb8fe0405a197f1e965a1fbf83e6c06006168daad4443c8" => :sierra
    sha256 "448e441af497efee9dc622d2a047299ef63c1f9ade2cbc7c86e0ed088ed69a73" => :el_capitan
    sha256 "83315218ef9ef5395b8552d0fc7967976fa0f6e66452d9844e665c9ecd8e8ba1" => :yosemite
  end

  option "with-pst2dii", "Build pst2dii using gd"

  deprecated_option "pst2dii" => "with-pst2dii"

  depends_on :python => :optional
  depends_on "pkg-config" => :build
  depends_on "gd" if build.with? "pst2dii"
  depends_on "boost"
  depends_on "gettext"
  depends_on "libgsf"
  depends_on "boost-python" if build.with? "python"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "--disable-dii" if build.with? "pst2dii"

    if build.with? "python"
      args << "--enable-python" << "--with-boost-python=mt"
    else
      args << "--disable-python"
    end

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"lspst", "-V"
  end
end
