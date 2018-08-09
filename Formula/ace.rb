class Ace < Formula
  desc "ADAPTIVE Communication Environment: OO network programming in C++"
  homepage "https://www.dre.vanderbilt.edu/~schmidt/ACE.html"
  url "http://download.dre.vanderbilt.edu/previous_versions/ACE-6.5.1.tar.bz2"
  sha256 "5e40bbb8e92689b670df88f1508cc182eee3a8094d04d13b3ad6de4cc1f490ef"

  bottle do
    cellar :any
    sha256 "d9f71bd66929a4c9cec44493e082ef7e9ca498856a8a13a00a8a4e092c2cac31" => :high_sierra
    sha256 "21343da4ddb48f2bd3cdf85c3beeed5842d5ecbf3fbda6b381bfec388528cfe3" => :sierra
    sha256 "7ffcd3851ffabb7f05a04933ea7ac3fe06f4a2a94076f90742427fddb4fc55be" => :el_capitan
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
