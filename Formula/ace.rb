class Ace < Formula
  desc "ADAPTIVE Communication Environment: OO network programming in C++"
  homepage "https://www.dre.vanderbilt.edu/~schmidt/ACE.html"
  url "https://github.com/DOCGroup/ACE_TAO/releases/download/ACE%2BTAO-6_5_4/ACE-6.5.4.tar.bz2"
  sha256 "66cfc68d1663dbd7a715d05632db5c0671a96706b6c9389d2d604e3ec5254563"

  bottle do
    cellar :any
    sha256 "dabec69bf7e2dfdca43438bae5d46745433c89fe9da7f05e83d7d5223829bfdd" => :mojave
    sha256 "573149b5895a410dd4f5b22887e690d00d8bed8636798720df13e0b7c247e860" => :high_sierra
    sha256 "62a169d5d0016e94bad130e0f24eb7be044e8c52b63e269b2bce2d4fbaf17776" => :sierra
  end

  def install
    ln_sf "config-macosx.h", "ace/config.h"
    ln_sf "platform_macosx.GNU", "include/makeinclude/platform_macros.GNU"

    # Set up the environment the way ACE expects during build.
    ENV["ACE_ROOT"] = buildpath
    ENV["DYLD_LIBRARY_PATH"] = "#{buildpath}/lib"

    # Done! We go ahead and build.
    system "make", "-C", "ace", "-f", "GNUmakefile.ACE",
                   "INSTALL_PREFIX=#{prefix}",
                   "LDFLAGS=",
                   "DESTDIR=",
                   "INST_DIR=/ace",
                   "debug=0",
                   "shared_libs=1",
                   "static_libs=0",
                   "install"

    system "make", "-C", "examples"
    pkgshare.install "examples"
  end

  test do
    cp_r "#{pkgshare}/examples/Log_Msg/.", testpath
    system "./test_callback"
  end
end
