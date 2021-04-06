class Calc < Formula
  desc "Arbitrary precision calculator"
  homepage "http://www.isthe.com/chongo/tech/comp/calc/"
  url "https://github.com/lcn2/calc/releases/download/v2.12.9.1/calc-2.12.9.1.tar.bz2"
  sha256 "077928f91353f8b612246d4fe5cba381131cd4e2610cfaa6d4e36b321fbb7c8e"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_big_sur: "0bd5c58bd1847be60eebaca0abb5d4f76368942634a19d232366450cde4aea61"
    sha256 big_sur:       "a550d9224166e7bcf109e192e4da8777cf85f1f69fd74e1104259ecb2c27246a"
    sha256 catalina:      "5dd7c1765ab13066b834004f04fbb79d9e440dc6cc78f8ad54c886c1e9825ca3"
    sha256 mojave:        "74cff552ee12dce587599b29f294446bb8a9d4449ee9495626aab969d78cb32d"
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
