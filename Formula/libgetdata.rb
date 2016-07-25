class Libgetdata < Formula
  desc "Reference implementation of the Dirfile Standards"
  homepage "http://getdata.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/getdata/getdata/0.9.3/getdata-0.9.3.tar.xz"
  sha256 "1b3766c18f01cf097bff213bef4ba1f6c0913527d9dd2a217bd1a9647fe07b35"

  bottle do
    cellar :any
    sha256 "ed19136a77b5c6cad977bdbf5bb5124d0b16515bc6906bc5b8d410cd5636c58a" => :el_capitan
    sha256 "11a7ef0416a4df76d1408872961e8d96e9d40c2c6d814c45eddd0d80464c78df" => :yosemite
    sha256 "f3181c8aab9763b649c26462b420839aed5c2241c60502a48842da8ed06c0926" => :mavericks
  end

  option "with-fortran", "Build Fortran 77 bindings"
  option "with-perl", "Build Perl binding"
  option "with-xz", "Build with LZMA compression support"
  option "with-libzzip", "Build with zzip compression support"

  deprecated_option "lzma" => "with-xz"
  deprecated_option "zzip" => "with-libzzip"

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
