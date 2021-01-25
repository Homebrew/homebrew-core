class Ispell < Formula
  desc "International Ispell"
  homepage "https://www.cs.hmc.edu/~geoff/ispell.html"
  url "https://www.cs.hmc.edu/~geoff/tars/ispell-3.4.02.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/i/ispell/ispell_3.4.02.orig.tar.gz"
  sha256 "6679604c3157fe54b2100905f3b52aaadfd23f46bb05a787188ec326f1c7d92c"

  livecheck do
    url :homepage
    regex(/href=.*?ispell[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "e27a92684329bd9c8bb2cb663b8a17f59519ed3e9eb9c04f1a1d145de4ec2726" => :big_sur
    sha256 "e360fc035e8d3a92e478a0e80609ccb39e5ca978cc3c8ed518aefd680401c2bd" => :arm64_big_sur
    sha256 "780428f2e0e4a6b8151af68c037b1059c479d642942a7609c25d343be08e40a4" => :catalina
    sha256 "14e8be247605fc01cacfeb0d115945217b028a1ff372f33fbe8132f03f88e9d8" => :mojave
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
