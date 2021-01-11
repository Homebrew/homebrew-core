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
    sha256 "75a7d1151e391d448d701efc762aa7edf259650d7ea791af8976ff0df7af204e" => :big_sur
    sha256 "c423e083a57993c9e4062eba90149026cc65c2ba99398f1a2d86ee1d061578cb" => :arm64_big_sur
    sha256 "fa1559da34ab3d95c700de2fb46b7a5ce03792c3d09ef57e5fea33af3111eb25" => :catalina
    sha256 "1d8a1a353f7f723c64a526d1046a09d9c8261943ad7ffdcd844201aaedbbe7d3" => :mojave
  end

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
