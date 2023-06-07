class Calc < Formula
  desc "Arbitrary precision calculator"
  homepage "http://www.isthe.com/chongo/tech/comp/calc/"
  url "https://downloads.sourceforge.net/project/calc/calc/2.14.1.6/calc-2.14.1.6.tar.bz2"
  sha256 "ce59b308296d181de2a6058117dbeedacce601982e3c3891d8adf17539d67f40"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_ventura:  "e89b35ab6e460691b6db9ca287e4f3674fba0ee4c70446029ede84b19812a636"
    sha256 arm64_monterey: "c6d86bfbe0f1ac063fdc49a063e1493f6ab257e266bbb6064dbf7250c37579b7"
    sha256 arm64_big_sur:  "c7d2c624da1fba4d63d96baceddd734f6d0fa8e4fe5e70ee3a4eb0a50adf3cb8"
    sha256 ventura:        "f22abfecb9b629b4d338eb5fe0588299ee2adb3cdbf1e0f8117563a773633ce0"
    sha256 monterey:       "b46dc71a097c01469df0aa341a5c738b6021a3ecb8afaf86edd3e09c0fcd1d92"
    sha256 big_sur:        "4ec2a6219a676a13210eb5df78a9effeaca295d83417a5e33dec75846d33b774"
    sha256 x86_64_linux:   "e5348ee17882348b0bd6a957e35e5db65cf705f522a2d1f35b39e164252f791a"
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
