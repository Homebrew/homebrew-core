class Libgetdata < Formula
  desc "Reference implementation of the Dirfile Standards"
  homepage "https://getdata.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/getdata/getdata/0.10.0/getdata-0.10.0.tar.xz"
  sha256 "d547a022f435b9262dcf06dc37ebd41232e2229ded81ef4d4f5b3dbfc558aba3"
  revision 1

  bottle do
    rebuild 1
    sha256 "7f5ee3942fe5c4b11be5a93d875ff57af244c4b5339ab4adf5f9a5784dd3ee20" => :high_sierra
    sha256 "c07420abe7db3df124e9203fbe88c0a39cca34edf7a6386449ac11c845b6210c" => :sierra
    sha256 "a08f8f9d9102484dc988c729e94d7864f40c655355edc4a85efd2b91bb2a2738" => :el_capitan
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
      --with-perl-dir=#{lib}/perl5/site_perl
    ]

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
