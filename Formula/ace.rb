class Ace < Formula
  desc "ADAPTIVE Communication Environment: OO network programming in C++"
  homepage "https://www.dre.vanderbilt.edu/~schmidt/ACE.html"
  url "https://github.com/DOCGroup/ACE_TAO/releases/download/ACE%2BTAO-6_5_9/ACE-6.5.9.tar.bz2"
  sha256 "7f42943b6c0b6aa76372a609d63d38a732e694457a0fc253c0fa69c488cbeee0"

  bottle do
    cellar :any
    sha256 "4baa37f7ba346213f8feb1aa2714f610b5331b8a61c56f519a6fcd0d1e50e26c" => :catalina
    sha256 "d89c56d8f19de0509b6d05f61d460f947d77ec4cb420470667156276d915f82d" => :mojave
    sha256 "6a3e770248a6d293a3aba98629a210c03e03bdfe4841d9632f80f0a63f4041ce" => :high_sierra
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
