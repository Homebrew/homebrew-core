class Ispell < Formula
  desc "International Ispell"
  homepage "https://www.cs.hmc.edu/~geoff/ispell.html"
  url "https://www.cs.hmc.edu/~geoff/tars/ispell-3.4.05.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/i/ispell/ispell_3.4.05.orig.tar.gz"
  sha256 "cf0c6dede3fd25fada4375d86acafe583cb96d8fe546de746a92ebb6df895602"
  license :cannot_represent # modified BSD license

  livecheck do
    url :homepage
    regex(/href=.*?ispell[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "a945c230dfa19ca5d6386e93175a9b783c981b986fb6b4706a87f23867f3dbfe"
    sha256 arm64_monterey: "cd60564b8dd85c18dcef91d4b5d90aa66fc4ccfbe2008009d33aa190554661bb"
    sha256 arm64_big_sur:  "e76131c8422ce43a180cf8d13fd74c2ff9073b82f9f749f50ddb27bda01bdaaa"
    sha256 monterey:       "eb6ac3922256a30c140ceb738cceacb4564ae5f80f23e06b0029743fda181902"
    sha256 big_sur:        "e5c67fdf342bda317f71d1fee34817164fb2d8ec5d14c0bf4313d0fdc50499d5"
    sha256 catalina:       "a21626f709579f26673e5bb5a9be7a5d8d58d4bcebb6d5ae214aca1cfc3bd6ab"
    sha256 x86_64_linux:   "a5a1ed2e6abadcda57b87db07c2e06746460a5ebcc085f5838ded950f4989998"
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
