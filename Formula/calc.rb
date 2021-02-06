class Calc < Formula
  desc "Arbitrary precision calculator"
  homepage "http://www.isthe.com/chongo/tech/comp/calc/"
  url "https://downloads.sourceforge.net/project/calc/calc/2.12.7.6/calc-2.12.7.6.tar.bz2"
  sha256 "3e0f27bd6f910f2d556fe5e0fb9b670f16445640fcd157101b26556b2abccec9"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_big_sur: "d64c698c14375806dfe5ab6026aac624ccd4156c65ca3587f320415745e528dd"
    sha256 big_sur:       "3d4821d5977cafef210d99e121549c43d0f0afb51302224380e94fc8b92be7b8"
    sha256 catalina:      "9c0fcfc9f4ae9db884ab809d0385fa6bcc34f86789bbe786a0330ef9b579bf79"
    sha256 mojave:        "02f1b5c6130bcb6bcacc6993997f8096c0dd5ef912822b52ed814b5e0214ed3b"
  end

  depends_on "readline"

  def install
    ENV.deparallelize

    ENV["EXTRA_CFLAGS"] = ENV.cflags
    ENV["EXTRA_LDFLAGS"] = ENV.ldflags

    args = [
      "BINDIR=#{bin}",
      "LIBDIR=#{lib}",
      "MANDIR=#{man1}",
      "CALC_INCDIR=#{include}/calc",
      "CALC_SHAREDIR=#{pkgshare}",
      "USE_READLINE=-DUSE_READLINE",
      "READLINE_LIB=-L#{Formula["readline"].opt_lib} -lreadline",
      "READLINE_EXTRAS=-lhistory -lncurses",
    ]
    on_macos do
      args << "INCDIR=#{MacOS.sdk_path}/usr/include"
    end
    system "make", "install", *args

    libexec.install "#{bin}/cscript"
  end

  test do
    assert_equal "11", shell_output("#{bin}/calc 0xA + 1").strip
  end
end
