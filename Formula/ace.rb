class Ace < Formula
  desc "ADAPTIVE Communication Environment: OO network programming in C++"
  homepage "https://www.dre.vanderbilt.edu/~schmidt/ACE.html"
  url "https://github.com/DOCGroup/ACE_TAO/releases/download/ACE%2BTAO-6_5_3/ACE-6.5.3.tar.bz2"
  sha256 "b1d6a716394bd15c21bb90037b8a12a4d8034cc9d8878b0ad39b3c467df19b1a"

  bottle do
    cellar :any
    sha256 "14eda7ed6a531986ee224f9a1ae4c5bf068b7ba958d8a82aa95830f03e4c51c8" => :mojave
    sha256 "99c5f0512bd685b9544b8adaf7386a2fc57a74aa22082f9e7e68ad477ed7c953" => :high_sierra
    sha256 "4919d255d1473ac444aa59877603a1adf234549c217c40b74aa06233e3eb6f74" => :sierra
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
