class Ace < Formula
  desc "ADAPTIVE Communication Environment: OO network programming in C++"
  homepage "https://www.dre.vanderbilt.edu/~schmidt/ACE.html"
  url "http://download.dre.vanderbilt.edu/previous_versions/ACE-6.3.4.tar.bz2"
  sha256 "9dd3c639fef1e4d3e2483f8cf4b201b2e80b1ffd8dd9c9a7ce57d0ba9e80f789"

  bottle do
    cellar :any
    revision 1
    sha256 "18c8fa1ffa10fc33f3c498a60a0e7a741a01dc8982e7e2141161f126baff2ec9" => :el_capitan
    sha256 "4b3d4e048ee9fe295844be6a2c1461f9391fd89f30e1603e8c2a8af636c1164f" => :yosemite
    sha256 "40f562e9afb830079075d9ae973ed73e071ac5ef0e610732d523949394aa4c99" => :mavericks
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
