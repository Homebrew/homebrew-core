class Dos2unix < Formula
  desc "Convert text between DOS, UNIX, and Mac formats"
  homepage "https://waterlan.home.xs4all.nl/dos2unix.html"
  url "https://waterlan.home.xs4all.nl/dos2unix/dos2unix-7.3.4.tar.gz"
  mirror "https://fossies.org/linux/misc/dos2unix-7.3.4.tar.gz"
  mirror "https://ftp.mirrorservice.org/sites/ftp.netbsd.org/pub/pkgsrc/distfiles/dos2unix-7.3.4.tar.gz"
  sha256 "8ccda7bbc5a2f903dafd95900abb5bf5e77a769b572ef25150fde4056c5f30c5"

  bottle do
    cellar :any_skip_relocation
    sha256 "299f292147015623269610f8824d3033279e6d5ef69c2b4750bd400adee189f1" => :sierra
    sha256 "1332065c48bd80eef7cfb3950265904cc1bfbba1485f8a0f2ef07254a4af08a3" => :el_capitan
    sha256 "0c403bed1fa9d5729e57efdb74a59cb82e66bd330ef065bf725fd6b0dc49d3b6" => :yosemite
    sha256 "45293b8d75ca820750b73a299499aa92c910a12089502d29da572db8a89cd6b4" => :mavericks
  end

  option "with-gettext", "Build with Native Language Support"

  depends_on "gettext" => :optional

  def install
    args = %W[
      prefix=#{prefix}
      CC=#{ENV.cc}
      CPP=#{ENV.cc}
      CFLAGS=#{ENV.cflags}
      install
    ]

    if build.without? "gettext"
      args << "ENABLE_NLS="
    else
      gettext = Formula["gettext"]
      args << "CFLAGS_OS=-I#{gettext.include}"
      args << "LDFLAGS_EXTRA=-L#{gettext.lib} -lintl"
    end

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
