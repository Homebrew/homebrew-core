class Calc < Formula
  desc "Arbitrary precision calculator"
  homepage "http://www.isthe.com/chongo/tech/comp/calc/"
  url "https://downloads.sourceforge.net/project/calc/calc/2.15.0.6/calc-2.15.0.6.tar.bz2"
  sha256 "89db710d005979ba93b312e85c2be4d1cb77379433454f988de2157e4d99e2a6"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sonoma:   "22d788ba36c9992c64c5d3021376e578d8cb49b95a77d5a1e617a9325fbd9880"
    sha256 arm64_ventura:  "6cb0cf9c7a057b49ee46d89bbb098deda5ac694dfb02946478d5b5b9008aa556"
    sha256 arm64_monterey: "7032440463f684f7b23b2776469cbc882ed2df38d759cec19fe693ca01cea5aa"
    sha256 sonoma:         "05bce6618fd62a00a62573164eb5fdc3a9bc9db2dbadfe4a066a8d03955ee239"
    sha256 ventura:        "35f76c8c0c97a8dfa90e724562081676162deeb632682b8b972d3b6ee987dc65"
    sha256 monterey:       "429309b1fb0eb91b69cf7222d4cb8afe4b6c022b6b2d97d0b1e80fac2129a38a"
    sha256 x86_64_linux:   "601f372082c0c9a30f6668340886cc6e637676dd17ee5667f6ad14a98c2630a5"
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
