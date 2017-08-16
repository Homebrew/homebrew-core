class Ace < Formula
  desc "ADAPTIVE Communication Environment: OO network programming in C++"
  homepage "https://www.dre.vanderbilt.edu/~schmidt/ACE.html"
  url "http://download.dre.vanderbilt.edu/previous_versions/ACE-6.4.4.tar.bz2"
  sha256 "35524e4153d0bc69410b1acbf6b8b41a47bc133eaeaa5201ad550b8284546810"

  bottle do
    cellar :any
    sha256 "b06d9bb0aedce6345014920369e2410163e50376aab5d7187e77dfcd8dc19bc8" => :sierra
    sha256 "a863fa3bce2444681586937fefb25ac1a99cc91d1f1a8301bc7e43196d1a7f35" => :el_capitan
    sha256 "c5fa5798354cffe15d49f27431adeb6a748074a63dca047efe9eea1ea5ad369f" => :yosemite
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
