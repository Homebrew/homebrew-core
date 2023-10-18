class Calc < Formula
  desc "Arbitrary precision calculator"
  homepage "http://www.isthe.com/chongo/tech/comp/calc/"
  url "https://downloads.sourceforge.net/project/calc/calc/2.15.0.1/calc-2.15.0.1.tar.bz2"
  sha256 "bbf9adf72e3cd392166037441f3f7874f6f857e778615aeb873cfcbf707eab6e"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sonoma:   "fb8bd25b074abe942badb1e416baf6751fb166dd1a4415f23a7b4300e1867629"
    sha256 arm64_ventura:  "d7f6f7f68f781aad6eecdfdd9d7b8d19eace11dbb4ab1376bd4281b5a529ec32"
    sha256 arm64_monterey: "ef5946cbf5670ad6f454f448088f27a1ebff203cf3e993027ca27cb73b4a989d"
    sha256 sonoma:         "ba9d9081584de319c5176cc217669e12fa880d4f31ddefcc11180e008dd5f371"
    sha256 ventura:        "2970596d4622cdb355fe547f5d755da6d5e23aa74c9a6326d01085c620e564c2"
    sha256 monterey:       "504ac17347059e264711610247f65ad78b67324fd90445f8fa4d11e7f7e7cfb0"
    sha256 x86_64_linux:   "0a3b5b9e5e63623ed09ee12e0e13e27c80f28dd7dddc2d971ad0b8238f9d79cb"
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
