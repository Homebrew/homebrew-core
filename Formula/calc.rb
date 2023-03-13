class Calc < Formula
  desc "Arbitrary precision calculator"
  homepage "http://www.isthe.com/chongo/tech/comp/calc/"
  url "https://downloads.sourceforge.net/project/calc/calc/2.14.1.5/calc-2.14.1.5.tar.bz2"
  sha256 "6cf69c62710905d42c20ff99f03fce0ec93211cbe1800cb7adae306ac60ca3a0"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_ventura:  "7f9663cd01ef3633137a33922b5d3879ab34ed277b0aac645617648fefb2806c"
    sha256 arm64_monterey: "4873fc4a3b988058ad6446ab3aaf4a761922efc4f5563f43e093239537b25806"
    sha256 arm64_big_sur:  "471c751b5f7f5929b65c66237c8de855c3d8f9f7e876362ffd3e035657653211"
    sha256 ventura:        "645261841ef3ca551dfbbfc730cead75d624e8c21114e5c89ddfbb73207e1d02"
    sha256 monterey:       "5444842f370cc516688cae97b699eff39e5baa33e3b6409ee34e3e2a43575aab"
    sha256 big_sur:        "3746be5e8f2e0b14e94ecee1e7b05d345d72639bf90790f78db9ead7956d768c"
    sha256 x86_64_linux:   "ca10329b580fc9d1e8dc2982ec460cfbdfa53c732a3bf9b05f91634d12785060"
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
