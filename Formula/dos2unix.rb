class Dos2unix < Formula
  desc "Convert text between DOS, UNIX, and Mac formats"
  homepage "https://waterlan.home.xs4all.nl/dos2unix.html"
  url "https://waterlan.home.xs4all.nl/dos2unix/dos2unix-7.4.1.tar.gz"
  mirror "https://fossies.org/linux/misc/dos2unix-7.4.1.tar.gz"
  sha256 "1cd58a60b03ed28fa39046102a185c5e88c4f7665e1e0417c25de7f8b9f78623"

  bottle do
    cellar :any_skip_relocation
    sha256 "e361c9877212a1666721d1b62348690d8dd24dadc94ef0f33b582c44b9650ab6" => :catalina
    sha256 "98ca83a3810ce6daa87546fbe821345859d943f7609389a52c2b59bf6cef03d3" => :mojave
    sha256 "24f1fc82e112c612641898b1e25d96c9f5b38442566041fce45c3b1aa998af09" => :high_sierra
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
