class Ace < Formula
  desc "ADAPTIVE Communication Environment: OO network programming in C++"
  homepage "https://www.dre.vanderbilt.edu/~schmidt/ACE.html"
  url "https://github.com/DOCGroup/ACE_TAO/releases/download/ACE%2BTAO-6_5_8/ACE-6.5.8.tar.bz2"
  sha256 "cda2a960dbb9970a907663627711b2e2b14b3484a2859ae936370bcad0b16923"

  bottle do
    cellar :any
    sha256 "24f272286dad9207b9f507d60d59edf72e5ce2200667e6296182ea4ca1bc04cf" => :catalina
    sha256 "7c1a02249b47273af65bcebd2a30e46923be0e5068946a4d1ecd752a7a0dd2a1" => :mojave
    sha256 "5bf3854c34d04fc15ea199f233355d2cac511492b94eefe109210d518acab3ed" => :high_sierra
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
