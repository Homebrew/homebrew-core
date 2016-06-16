class Libgetdata < Formula
  desc "Reference implementation of the Dirfile Standards"
  homepage "http://getdata.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/getdata/getdata/0.9.2.1/getdata-0.9.2.1.tar.xz"
  sha256 "e41d82abdb86577ce41600f187a4271e17e544b67dc0e0518d42f285cd809499"

  bottle do
    cellar :any
    sha256 "7395337146c678b1759f9a9a8ce7c579f2eb014571fc063c741702d3a1e43c31" => :el_capitan
    sha256 "245625c558e690197d5b86e8a80f07b18ccdcbfe1de4fb829c652991ba79be5d" => :yosemite
    sha256 "f1af1ab131a848cf8976511a2e74bdc38c3b615fe207d8f504e5ca5a7f4c171b" => :mavericks
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
