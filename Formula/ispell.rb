class Ispell < Formula
  desc "International Ispell"
  homepage "https://www.cs.hmc.edu/~geoff/ispell.html"
  url "https://www.cs.hmc.edu/~geoff/tars/ispell-3.4.04.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/i/ispell/ispell_3.4.04.orig.tar.gz"
  sha256 "87bcd6f0521d85a0a3a7834215956d74ebc493144cc7c791f87be6872ccfe13e"

  livecheck do
    url :homepage
    regex(/href=.*?ispell[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "62553e9203c1553d699d0014224a6ff9f934844a3377b90362e2d33ed079f2dd"
    sha256 arm64_big_sur:  "f48b72490babfc3d3debf6eeeb34fb27516dd7a360322e05217f75f9a060642d"
    sha256 monterey:       "4cb7e05fb71b9db13a497fd2ef4df875187e5ba1976c79e8776aa9fbe2f6da63"
    sha256 big_sur:        "ed399105823ef8d4c978b9f29675fe52766cefb3c33e969a36fc0ff0e33dba13"
    sha256 catalina:       "bd78389107e1457352b3c9eb88a73d434cffae5764455ea461e4c201f5180b85"
    sha256 mojave:         "85bb0fb8d13a18cffdc0ddd2e9ed1d4d007b884967d0952a7a174135ea5cc416"
    sha256 x86_64_linux:   "83022ccd0a50207196c2d29a2b3c08003157b1e77bb48ed796baa4e9c3e9092f"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "ncurses"

  def install
    ENV.deparallelize

    # No configure script, so do this all manually
    cp "local.h.macos", "local.h"
    chmod 0644, "local.h"
    inreplace "local.h" do |s|
      s.gsub! "/usr/local", prefix
      s.gsub! "/man/man", "/share/man/man"
      s.gsub! "/lib", "/lib/ispell"
    end

    chmod 0644, "correct.c"
    inreplace "correct.c", "getline", "getline_ispell"

    system "make", "config.sh"
    chmod 0644, "config.sh"
    inreplace "config.sh", "/usr/share/dict", "#{share}/dict"

    (lib/"ispell").mkpath
    system "make", "install"
  end

  test do
    assert_equal "BOTHER BOTHE/R BOTH/R",
                 `echo BOTHER | #{bin}/ispell -c`.chomp
  end
end
