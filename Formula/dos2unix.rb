class Dos2unix < Formula
  desc "Convert text between DOS, UNIX, and Mac formats"
  homepage "https://waterlan.home.xs4all.nl/dos2unix.html"
  url "https://waterlan.home.xs4all.nl/dos2unix/dos2unix-7.3.4.tar.gz"
  mirror "https://fossies.org/linux/misc/dos2unix-7.3.4.tar.gz"
  mirror "https://ftp.mirrorservice.org/sites/ftp.netbsd.org/pub/pkgsrc/distfiles/dos2unix-7.3.4.tar.gz"
  sha256 "8ccda7bbc5a2f903dafd95900abb5bf5e77a769b572ef25150fde4056c5f30c5"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "d039be7c3fbfed7196887792433d3838e8fe7df2c49a2af7112a0116e419146a" => :el_capitan
    sha256 "7c2523cbddc1427e7070820215ce8ffd0eaddeb855202334a000d1604b0fb996" => :yosemite
    sha256 "75ec10f6c40f4173643989f4d5a7c134f059e24432a1ac1647610da9a6d16ef5" => :mavericks
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
