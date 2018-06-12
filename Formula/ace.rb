class Ace < Formula
  desc "ADAPTIVE Communication Environment: OO network programming in C++"
  homepage "https://www.dre.vanderbilt.edu/~schmidt/ACE.html"
  url "http://download.dre.vanderbilt.edu/previous_versions/ACE-6.5.0.tar.bz2"
  sha256 "dbfbb6b7747de2c5de101403b1ccd7b673ea5a31e7492504467070b98ef5f357"

  bottle do
    cellar :any
    sha256 "175cacc70ba31d16f3f4164dc1fd396d16e3704c59689a1b818797670a6c02e5" => :high_sierra
    sha256 "a10e87b8769efac558f3535e41a0db5b466245639b87502af192b468c9d71f06" => :sierra
    sha256 "2c73d74210e36592f453c08c9ec5c8ac994985bafecc6383604edc01bd0cf4be" => :el_capitan
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
