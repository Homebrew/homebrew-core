class Calc < Formula
  desc "Arbitrary precision calculator"
  homepage "http://www.isthe.com/chongo/tech/comp/calc/"
  url "https://github.com/lcn2/calc/archive/refs/tags/v2.15.1.1.tar.gz"
  sha256 "ad432c3202885fb93a82985c0a9cdd4c82f3877acc8f12a1504f56c8359e6bee"
  license "LGPL-2.1-or-later"
  head "https://github.com/lcn2/calc.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "1b0afcde0fd8484cdcadea8a20e21a5c0b5d086aa43c56d63e7d8e21206247cc"
    sha256 arm64_sequoia: "473e3761dcf18e6c8f0657eee8a690ba5b094c55bb79c44e28e110cd80ed58f3"
    sha256 arm64_sonoma:  "8897a859be300533821ba09c5c681158940be5ac85b4f4736a074bc3db3e1560"
    sha256 arm64_ventura: "de564162098982b1546f3243c618ba8731160442d0efb0be360bc50044a1dd19"
    sha256 sonoma:        "3363fbda78c962b3b57f945a3c368add2c043ce8f344fec0d0d23177d71e82c9"
    sha256 ventura:       "eeaf9f4a77a5d6427d7f1802d9d4a402605d0aa66fcbadb9ced944520a13dff7"
    sha256 arm64_linux:   "b13ca7062d6d574f01430e5dac76a5450360f2c4eadf6772f258db194dd16040"
    sha256 x86_64_linux:  "762c4ff259e90fcbc371703b1a311a7716cb4ff228957d0499aebe46b163e2fb"
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
