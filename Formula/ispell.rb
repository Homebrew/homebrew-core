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
    sha256 arm64_big_sur: "206bac064616192692a52cd0fb8f64138cc685a0d2765ce21ba1889672a3558b"
    sha256 big_sur:       "bb31a94a6248a8298f8f93ba6175336aa4b7e1297440d9cea7af22be117170f9"
    sha256 catalina:      "d588636ea56a940732b17181ad84b1b22b906314f5cbc2171aad5bce76812903"
    sha256 mojave:        "9fe86ce46da93f3f73b2c7ad3bd079d5a4eae7dd86c7ab638841eb5a21895ea7"
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
