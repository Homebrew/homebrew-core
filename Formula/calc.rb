class Calc < Formula
  desc "Arbitrary precision calculator"
  homepage "http://www.isthe.com/chongo/tech/comp/calc/"
  url "https://downloads.sourceforge.net/project/calc/calc/2.14.0.14/calc-2.14.0.14.tar.bz2"
  sha256 "f7727835a103d9712c571958e924e9c254bd148f08eb4348019bc34f8e71c55d"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_monterey: "fe2cea432314e3e0e10274f1b7cd2ad1463fb2373232700dd3e5770fa1dcbdde"
    sha256 arm64_big_sur:  "a86beba94ff8f064c8b9fc825346229180e1bf29ef20ca10a0a2a7f1d0f2159c"
    sha256 monterey:       "2882f7899a27dee232524e42f9824ef8f4f418fa8725db74f01183bc32ea7cc4"
    sha256 big_sur:        "51ce4745fbd8afea2a468e3649acf244846d7b95a153782dd01fc2287799a7f9"
    sha256 catalina:       "7ef5ffd4d6120c70d7a1821a8ba8be26feceb474567eb85c2664cff09132c45c"
    sha256 x86_64_linux:   "3daa20723bd1b4e1573d76e335920b0d98e311b421f1849dc221fb190686c83b"
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
