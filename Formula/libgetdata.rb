class Libgetdata < Formula
  desc "Reference implementation of the Dirfile Standards"
  homepage "https://getdata.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/getdata/getdata/0.10.0/getdata-0.10.0.tar.xz"
  sha256 "d547a022f435b9262dcf06dc37ebd41232e2229ded81ef4d4f5b3dbfc558aba3"
  revision 1

  bottle do
    rebuild 2
    sha256 "13e9d36f7ee8156ad9b5ffaa646588084e9212238aafbab50849f60c6cad0ab9" => :high_sierra
    sha256 "9a96ebcf2d456594b5205c2ff0918dc7bcfff29be358fd6e369131f941e02f75" => :sierra
    sha256 "88055dcabc5ed8b6cc068e244f8174eb798fd778e67a27867b3a0b33b3453121" => :el_capitan
  end

  option "with-gcc", "Build Fortran bindings"
  option "with-libzzip", "Build with zzip compression support"
  option "with-perl", "Build against Homebrew's Perl rather than system default"
  option "with-xz", "Build with LZMA compression support"

  deprecated_option "lzma" => "with-xz"
  deprecated_option "zzip" => "with-libzzip"
  deprecated_option "with-fortran" => "with-gcc"

  depends_on "libtool" => :run
  depends_on "gcc" => :optional
  depends_on "libzzip" => :optional
  depends_on "perl" => :optional
  depends_on "xz" => :optional

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --disable-php
      --disable-python
    ]

    args << "--with-perl-dir=#{lib}/perl5/site_perl" if build.with? "perl"
    args << "--without-liblzma" if build.without? "xz"
    args << "--without-libzzip" if build.without? "libzzip"
    args << "--disable-fortran" << "--disable-fortran95" if build.without? "gcc"

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "GetData #{version}", shell_output("#{bin}/checkdirfile --version", 1)
  end
end
