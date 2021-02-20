class Calc < Formula
  desc "Arbitrary precision calculator"
  homepage "http://www.isthe.com/chongo/tech/comp/calc/"
  url "https://downloads.sourceforge.net/project/calc/calc/2.12.8.1/calc-2.12.8.1.tar.bz2"
  sha256 "4f055cb86696220cc4737e031441857267245ebc19e2bb91aac7a5242973d79a"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_big_sur: "a18abe9bca4030cb88fc6cc361dfb167eaddec71c47e5f4f0935b5dde69f3c4e"
    sha256 big_sur:       "9d66bbfebcbb9ec5adeb95e763f3249355256a63ab450bd6fcded909aafe7935"
    sha256 catalina:      "bbacc31ff7b0ae0f36ef94d1956bc26f8d007b0091deb77b41e16c6d189d0f6b"
    sha256 mojave:        "2d5fe9a9130fa99949848c9341c233e774b298d5fc7f66f041f4653eb8bc82d7"
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
