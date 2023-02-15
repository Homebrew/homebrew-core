class Calc < Formula
  desc "Arbitrary precision calculator"
  homepage "http://www.isthe.com/chongo/tech/comp/calc/"
  url "https://downloads.sourceforge.net/project/calc/calc/2.14.1.3/calc-2.14.1.3.tar.bz2"
  sha256 "e5a02f6338c09292d919ff5413e4dad7c228f44c0fefaf726255729221f8a9dd"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_ventura:  "f844602ab7ca1eae9b8e68fdddd8e0a7adac5b0b041822ef53e746f3d1fa5f33"
    sha256 arm64_monterey: "0f2e85cb8f9ab38d2caf834679ef3c7f2458d3d171e99f3fabc2e0ad94478897"
    sha256 arm64_big_sur:  "b03e62edcea9b59b4bd47b4476acf5d4af89e90250ce179097fde3085ee11f3f"
    sha256 ventura:        "b2f85f5877135d58b5bfb2129d245fffdb1fb0b0f2ad388a65e122b689acda9f"
    sha256 monterey:       "c78188011254f192eb8b6ccd9c2eb4bff2629cef4c3ddfcca819a3e76f8f6119"
    sha256 big_sur:        "d4f5aec08ddb68c537f2176e24ac8e6512e393ab66720abad6f69776d890a634"
    sha256 catalina:       "d405782df1dcc996323afcd33b1940fcbca1527c164b403c26d24657e551a88b"
    sha256 x86_64_linux:   "e53d63845a3d9c8844118575b5d89817540e438eb4935bedc91215f0ad064f41"
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
