class Ace < Formula
  desc "ADAPTIVE Communication Environment: OO network programming in C++"
  homepage "https://www.dre.vanderbilt.edu/~schmidt/ACE.html"
  url "http://download.dre.vanderbilt.edu/previous_versions/ACE-6.3.4.tar.bz2"
  sha256 "9dd3c639fef1e4d3e2483f8cf4b201b2e80b1ffd8dd9c9a7ce57d0ba9e80f789"

  bottle do
    cellar :any
    sha256 "a52a47e981ba575a1b43030bbc0abf2aacfb219b6c2b3d093cc09cd625488777" => :el_capitan
    sha256 "2c00224c6b36ee70552868d953631c77738acfba5d4d6de9b3df5c4b1829b1b4" => :yosemite
    sha256 "f7da478aa4950a96b33966d2ae0f2ea2a3b87f0d87fc141f8dce4e95fcbfaf2f" => :mavericks
  end

  def install
    # Figure out the names of the header and makefile for this version
    # of OSX and link those files to the standard names.
    name = MacOS.cat.to_s.delete "_"
    ln_sf "config-macosx-#{name}.h", "ace/config.h"
    ln_sf "platform_macosx_#{name}.GNU", "include/makeinclude/platform_macros.GNU"

    # Set up the environment the way ACE expects during build.
    ENV["ACE_ROOT"] = buildpath
    ENV["DYLD_LIBRARY_PATH"] = "#{buildpath}/ace:#{buildpath}/lib"

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
