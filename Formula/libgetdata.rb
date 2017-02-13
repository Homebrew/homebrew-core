class Libgetdata < Formula
  desc "Reference implementation of the Dirfile Standards"
  homepage "https://getdata.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/getdata/getdata/0.10.0/getdata-0.10.0.tar.xz"
  sha256 "d547a022f435b9262dcf06dc37ebd41232e2229ded81ef4d4f5b3dbfc558aba3"

  bottle do
    sha256 "f0639bcf8df22e92c5bc2979c4c52834a2dd9ead9793905f3de9ef7002f23950" => :sierra
    sha256 "8de8292bee505449d012e63b38549a8f623d4b50962d3e04442917522466f63c" => :el_capitan
    sha256 "560fae5df4e8c5d308589ab7a0e04694a681d725bf492d7a31817cbf42aadd27" => :yosemite
  end

  option "with-fortran", "Build Fortran 77 bindings"
  option "with-perl", "Build Perl binding"
  option "with-xz", "Build with LZMA compression support"
  option "with-libzzip", "Build with zzip compression support"

  deprecated_option "lzma" => "with-xz"
  deprecated_option "zzip" => "with-libzzip"

  depends_on "libtool" => :run
  depends_on :fortran => :optional
  depends_on :perl => ["5.3", :optional]
  depends_on "xz" => :optional
  depends_on "libzzip" => :optional

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --disable-python
      --disable-php
    ]

    if build.with? "perl"
      args << "--with-perl-dir=#{lib}/perl5/site_perl"
    else
      args << "--disable-perl"
    end
    args << "--without-liblzma" if build.without? "xz"
    args << "--without-libzzip" if build.without? "libzzip"
    args << "--disable-fortran" << "--disable-fortran95" if build.without? "fortran"

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "GetData #{version}", shell_output("#{bin}/checkdirfile --version", 1)
  end
end
