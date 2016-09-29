class Libgetdata < Formula
  desc "Reference implementation of the Dirfile Standards"
  homepage "http://getdata.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/getdata/getdata/0.9.4/getdata-0.9.4.tar.xz"
  sha256 "4a26598f6051cf9a5f8c68fd2440584769265533a89e03690eceecae91a2334e"

  bottle do
    cellar :any
    sha256 "ab52207909d2fcd396832033025e92919ac9cee48ea8130237f5754d708763d3" => :sierra
    sha256 "d6116c4022879f1dc303bf31b9be3a5a7d7845e5fdd1d5d68047914578eaf22b" => :el_capitan
    sha256 "8593fb78389ccfce38166737d9f45f20b2794994faaa0e93f8262547884d79d6" => :yosemite
    sha256 "ba874af6ad662404f9840cf26a0bf11a78c600be4942fda0b2024340cc90ac4d" => :mavericks
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
