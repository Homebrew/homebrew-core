class Calc < Formula
  desc "Arbitrary precision calculator"
  homepage "http://www.isthe.com/chongo/tech/comp/calc/"
  url "https://downloads.sourceforge.net/project/calc/calc/2.15.1.0/calc-2.15.1.0.tar.bz2"
  sha256 "633df610a5f5d2f69ad377e320afc85009052b4acc245f0586cbf932a179e2d6"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sequoia:  "d5522f39a915d85ae4fac013aad878a11f71228e3cc972a3149d6b33f1af92eb"
    sha256 arm64_sonoma:   "1bb4b0d615a345ad8b9b93ae42415ec5859f752ceb34b8dc031f4c29d1a2ac86"
    sha256 arm64_ventura:  "fde7ae06ed20db156d90e1c05e691531d9e7a3a409f9ce9b117b216e6914f781"
    sha256 arm64_monterey: "15f728d7d5f1e0547fa8e8e74b6cb98cf7bd15ef488a2385f89a650d1bfc3389"
    sha256 sonoma:         "8eb4e34f1a3b55392b9cee759415595863a790dc391814b574f8515fb968f14d"
    sha256 ventura:        "ac313396a34754426514eb0fe001e4fba32653dd14e532613abe5ee1374b74f8"
    sha256 monterey:       "dc68f56dc6b3a7d6891e6cef15bebfa9c681d431408c1e93f05a05b40dc87417"
    sha256 x86_64_linux:   "deaffb8e67645aa29842b78bd50596bc7cd460f0b826d88babe74af2ca1f7be7"
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
