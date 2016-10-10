class Ace < Formula
  desc "ADAPTIVE Communication Environment: OO network programming in C++"
  homepage "https://www.dre.vanderbilt.edu/~schmidt/ACE.html"
  url "http://download.dre.vanderbilt.edu/previous_versions/ACE-6.4.1.tar.bz2"
  sha256 "4c74a30a1d013624a2426fd6e0a4791eca4ca8979065e52f7daebda7289dd23e"

  bottle do
    cellar :any
    sha256 "d3fb63e3d1e4408283e7547dfd409bdba157e2d3e62ba1b3066ed3ed10533576" => :sierra
    sha256 "316275bf43b05b13a96a7a30105dc3c64cc34bf8d437e77238e3922ceddacb5b" => :el_capitan
    sha256 "b865dc9968a6a29cc1c9e1f87a4a08560bdd8ee2e59db53732e3e4a7ea8f94f7" => :yosemite
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

    system "make", "-C", "examples/Log_Msg"
    pkgshare.install "examples/Log_Msg"
  end

  test do
    cp_r "#{pkgshare}/examples/Log_Msg/.", testpath
    system "./test_callback"
  end
end
