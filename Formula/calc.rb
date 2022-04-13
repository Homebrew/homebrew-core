class Calc < Formula
  desc "Arbitrary precision calculator"
  homepage "http://www.isthe.com/chongo/tech/comp/calc/"
  url "https://downloads.sourceforge.net/project/calc/calc/2.14.1.0/calc-2.14.1.0.tar.bz2"
  sha256 "0b5616652e31ee1b54585dcc8512d02180a12f8addc09c4049d3d08edb54af40"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_monterey: "ea07735f46f25fcc12ff0f33fad7ff9c3efc218dff305d70fd38d0891b38b186"
    sha256 arm64_big_sur:  "b5f5d23071f8a9117b26dd7b935b5480fe596abf76cf332ce1fec8f07b83787f"
    sha256 monterey:       "c028e2df8a879fb2eefcfa80a3e09215791ae6badd0ec95dd55cd1534c3ae2f7"
    sha256 big_sur:        "45786113d02519ba1817f09324559793bfb8fa30c9ce7752adef907c382ef1de"
    sha256 catalina:       "6b43aed5f60f6fe49e448b1c858bfffae34e6892fa0ffc9fbd0ea341e8f45e32"
    sha256 x86_64_linux:   "a32c0df48ae60626fd60efd3310b091cea83d2c9db4ff1ebd54ba8d23fabf1b0"
  end

  depends_on "readline"

  on_linux do
    depends_on "util-linux" # for `col`
  end

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
    args << "INCDIR=#{MacOS.sdk_path}/usr/include" if OS.mac?
    system "make", "install", *args

    libexec.install "#{bin}/cscript"
  end

  test do
    assert_equal "11", shell_output("#{bin}/calc 0xA + 1").strip
  end
end
