class Libgetdata < Formula
  desc "Reference implementation of the Dirfile Standards"
  homepage "https://getdata.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/getdata/getdata/0.10.0/getdata-0.10.0.tar.xz"
  sha256 "d547a022f435b9262dcf06dc37ebd41232e2229ded81ef4d4f5b3dbfc558aba3"
  revision 1

  bottle do
    sha256 "bf29e7e39c8a2acd7c48b9668c679c1e686439fea6452a3b6009d140d3849aee" => :high_sierra
    sha256 "f0639bcf8df22e92c5bc2979c4c52834a2dd9ead9793905f3de9ef7002f23950" => :sierra
    sha256 "8de8292bee505449d012e63b38549a8f623d4b50962d3e04442917522466f63c" => :el_capitan
    sha256 "560fae5df4e8c5d308589ab7a0e04694a681d725bf492d7a31817cbf42aadd27" => :yosemite
  end

  option "with-fortran", "Build Fortran bindings"
  option "with-xz", "Build with LZMA compression support"
  option "with-libzzip", "Build with zzip compression support"

  deprecated_option "lzma" => "with-xz"
  deprecated_option "zzip" => "with-libzzip"

  depends_on "libtool" => :run
  depends_on "gcc" if build.with?("fortran")
  depends_on "libzzip" => :optional
  depends_on "xz" => :optional

  def install
    ENV.fortran if build.with?("fortran")

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --disable-php
      --disable-python
      --with-perl-dir=#{lib}/perl5/site_perl
    ]

    args << "--without-liblzma" if build.without? "xz"
    args << "--without-libzzip" if build.without? "libzzip"
    if build.without? "fortran"
      args << "--disable-fortran" << "--disable-fortran95"
    end

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "GetData #{version}", shell_output("#{bin}/checkdirfile --version", 1)
  end
end
