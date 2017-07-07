class Dos2unix < Formula
  desc "Convert text between DOS, UNIX, and Mac formats"
  homepage "https://waterlan.home.xs4all.nl/dos2unix.html"
  url "https://waterlan.home.xs4all.nl/dos2unix/dos2unix-7.3.5.tar.gz"
  mirror "https://fossies.org/linux/misc/dos2unix-7.3.5.tar.gz"
  mirror "https://ftp.mirrorservice.org/sites/ftp.netbsd.org/pub/pkgsrc/distfiles/dos2unix-7.3.5.tar.gz"
  sha256 "a72caa2fb5cb739403315472fe522eda41aabab2a02ad6f5589639330af262e5"

  bottle do
    cellar :any_skip_relocation
    sha256 "2adbb06b9540a4f51320966d0b33c1a283cf062e0815783d224c16acc8baf12c" => :sierra
    sha256 "8564e8a0c5fdf5ca3e8f6c19143c3b5641d066dd27873f0b901f878a566b4ec7" => :el_capitan
    sha256 "a75761f15f052f836e743d68e9125deecb49dacc839f831e90c99e2fcca5f45c" => :yosemite
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
