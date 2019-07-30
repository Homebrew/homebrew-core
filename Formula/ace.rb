class Ace < Formula
  desc "ADAPTIVE Communication Environment: OO network programming in C++"
  homepage "https://www.dre.vanderbilt.edu/~schmidt/ACE.html"
  url "https://github.com/DOCGroup/ACE_TAO/releases/download/ACE%2BTAO-6_5_6/ACE-6.5.6.tar.bz2"
  sha256 "24dee8978def5f9e538c13d2f86c63631d9406c316d6b89ddc90149411938e96"

  bottle do
    cellar :any
    sha256 "8520826a33a990c1bcfd7a63b4608acc562a393fd6c343e1c3f9a47d073b36b9" => :mojave
    sha256 "242fc7e530c52a7037f3ca1fe1dde31dc9abfb0b04201c52c179d46e6f2640b0" => :high_sierra
    sha256 "d62e51833b09a4e4894d1651ecde2b8bfd60a605aaedb6947009496b81bbd703" => :sierra
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
