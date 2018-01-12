class Libgetdata < Formula
  desc "Reference implementation of the Dirfile Standards"
  homepage "https://getdata.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/getdata/getdata/0.10.0/getdata-0.10.0.tar.xz"
  sha256 "d547a022f435b9262dcf06dc37ebd41232e2229ded81ef4d4f5b3dbfc558aba3"
  revision 1

  bottle do
    sha256 "1b95b35bec7262c88e39c32339f471148b7eebcf58b75a2defce49e6428304eb" => :high_sierra
    sha256 "12a4d19d85cc83d98bf1ddf643d67298613a380c83392638e03e5be1d28e8087" => :sierra
    sha256 "8325146db660599ac119ab62e994c41cce2924db4b80d1a215e0ea7a45b9bd34" => :el_capitan
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
