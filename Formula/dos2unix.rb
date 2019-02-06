class Dos2unix < Formula
  desc "Convert text between DOS, UNIX, and Mac formats"
  homepage "https://waterlan.home.xs4all.nl/dos2unix.html"
  url "https://waterlan.home.xs4all.nl/dos2unix/dos2unix-7.4.0.tar.gz"
  mirror "https://fossies.org/linux/misc/dos2unix-7.4.0.tar.gz"
  sha256 "bac765abdbd95cdd87a71989d4382c32cf3cbfeee2153f0086cb9cf18261048a"

  bottle do
    cellar :any_skip_relocation
    sha256 "9d5df92d5602611e461f368404a7e29fa1499d0edd9342847e990282ad8e0f54" => :mojave
    sha256 "6aca83a413b4c2b2645e7a17e02dcae91c4f0ae9d2dba430e8083266e5a06482" => :high_sierra
    sha256 "51ccc96a8757320d073beb4ed224a65130c454bbe249c58157c5921e8ed9fe2c" => :sierra
    sha256 "e0d2b2e99417be33b385a47f847e8838dc75b2ccdb5277b1d9ba031c4fe55b23" => :el_capitan
  end

  def install
    args = %W[
      prefix=#{prefix}
      CC=#{ENV.cc}
      CPP=#{ENV.cc}
      CFLAGS=#{ENV.cflags}
      ENABLE_NLS=
      install
    ]

    system "make", *args
  end

  test do
    # write a file with lf
    path = testpath/"test.txt"
    path.write "foo\nbar\n"

    # unix2mac: convert lf to cr
    system "#{bin}/unix2mac", path
    assert_equal "foo\rbar\r", path.read

    # mac2unix: convert cr to lf
    system "#{bin}/mac2unix", path
    assert_equal "foo\nbar\n", path.read

    # unix2dos: convert lf to cr+lf
    system "#{bin}/unix2dos", path
    assert_equal "foo\r\nbar\r\n", path.read

    # dos2unix: convert cr+lf to lf
    system "#{bin}/dos2unix", path
    assert_equal "foo\nbar\n", path.read
  end
end
