class Calc < Formula
  desc "Arbitrary precision calculator"
  homepage "http://www.isthe.com/chongo/tech/comp/calc/"
  url "http://www.isthe.com/chongo/src/calc/calc-2.12.5.0.tar.bz2"
  sha256 "a0e7b47af38330f188970998c8e5039134dadf6f2e3f2c00d7efdae272a4338d"
  revision 1

  bottle do
    sha256 "dd0ed50f3e98e105a46b378352bfecda1562c9bb79524d77a63fc7ec46e8ed64" => :sierra
    sha256 "4e7746c70e2bc113ff9bdc0308ebf5b79a58aca2dc0b208d0cb1dce698714abd" => :el_capitan
    sha256 "23fd7dc2862b7f8f139d2b2e7263f478d9b1b45c5be7c8f6665cd8adfca78f28" => :yosemite
  end

  depends_on "readline"

  def install
    ENV.deparallelize

    ENV["EXTRA_CFLAGS"] = ENV.cflags
    ENV["EXTRA_LDFLAGS"] = ENV.ldflags

    readline = Formula["readline"]
    inreplace "Makefile" do |s|
      s.change_make_var! "INCDIR", "#{MacOS.sdk_path}/usr/include"
      s.change_make_var! "BINDIR", bin
      s.change_make_var! "LIBDIR", lib
      s.change_make_var! "MANDIR", man1
      s.change_make_var! "CALC_INCDIR", "#{include}/calc"
      s.change_make_var! "CALC_SHAREDIR", pkgshare
      s.change_make_var! "USE_READLINE", "-DUSE_READLINE"
      s.change_make_var! "READLINE_LIB", "-L#{readline.lib} -lreadline"
      s.change_make_var! "READLINE_EXTRAS", "-lhistory -lncurses"
    end

    system "make"
    system "make", "install"
    libexec.install "#{bin}/cscript"
  end

  test do
    assert_equal "11", shell_output("#{bin}/calc 0xA + 1").strip
  end
end
