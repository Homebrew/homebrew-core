class Ace < Formula
  desc "ADAPTIVE Communication Environment: OO network programming in C++"
  homepage "https://www.dre.vanderbilt.edu/~schmidt/ACE.html"
  url "https://github.com/DOCGroup/ACE_TAO/releases/download/ACE%2BTAO-6_5_6/ACE-6.5.6.tar.bz2"
  sha256 "24dee8978def5f9e538c13d2f86c63631d9406c316d6b89ddc90149411938e96"

  bottle do
    cellar :any
    sha256 "5b0b6a3f10b0571a8e43c87775549656c8ce7cd570f41280ee1ea0e38e6eec72" => :mojave
    sha256 "c68f8ab97f479dc1c12e0e6170b5a0b9989516d4747523acbd2bdb7e0bbd0df8" => :high_sierra
    sha256 "6f14c5dab800a066ca6b0547b9473fa89e73adaec424d0f3780cc83a18f9a84c" => :sierra
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
