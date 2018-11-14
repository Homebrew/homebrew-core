class Calc < Formula
  desc "Arbitrary precision calculator"
  homepage "http://www.isthe.com/chongo/tech/comp/calc/"
  url "https://downloads.sourceforge.net/project/calc/calc/2.12.7.1/calc-2.12.7.1.tar.bz2"
  sha256 "eb1dc5dd680019e30264109167e20539fe9ac869049d8b1639781a51d1dea84c"

  bottle do
    sha256 "4e766215d68c33ce4eccf7856549aa179a44b76008230cf8560057798262e3e7" => :mojave
    sha256 "cdd8b3cb08bc725934ad4ae10c691325a97ee7a1e441d30469729fa98222827a" => :high_sierra
    sha256 "4af7c47ad39d8992203f12e7d8085e0c83735bff0b3c2e4df4e64e31edfe6ddf" => :sierra
  end

  depends_on "readline"

  def install
    ENV.deparallelize

    ENV["EXTRA_CFLAGS"] = ENV.cflags
    ENV["EXTRA_LDFLAGS"] = ENV.ldflags

    readline = Formula["readline"]

    system "make", "install", "INCDIR=#{MacOS.sdk_path}/usr/include",
                              "BINDIR=#{bin}",
                              "LIBDIR=#{lib}",
                              "MANDIR=#{man1}",
                              "CALC_INCDIR=#{include}/calc",
                              "CALC_SHAREDIR=#{pkgshare}",
                              "USE_READLINE=-DUSE_READLINE",
                              "READLINE_LIB=-L#{readline.opt_lib} -lreadline",
                              "READLINE_EXTRAS=-lhistory -lncurses"
    libexec.install "#{bin}/cscript"
  end

  test do
    assert_equal "11", shell_output("#{bin}/calc 0xA + 1").strip
  end
end
