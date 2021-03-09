class Calc < Formula
  desc "Arbitrary precision calculator"
  homepage "http://www.isthe.com/chongo/tech/comp/calc/"
  url "https://downloads.sourceforge.net/project/calc/calc/2.12.8.2/calc-2.12.8.2.tar.bz2"
  sha256 "c8a7b83c04a6eea587fe762ff01b586e2f66df13e9034499d361da863f03242f"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_big_sur: "2ed9ab87b102f1729dc58994affb84f6fa67caeb964cf4639ed79c671bc87b02"
    sha256 big_sur:       "a0a583b1ee62e8bcf1309dab84f0a3942868c8fbbf6d960bc601bb51b666518e"
    sha256 catalina:      "95af9febbfae1d4053bcc14ef9a89c57601a0f44245b06e8cfb7ec9ab79ee3be"
    sha256 mojave:        "0e01ee7002ebddde2f52ac6202033e54bde01501f4cf30cea19a053b28cd7b7d"
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
