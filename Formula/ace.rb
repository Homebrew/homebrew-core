class Ace < Formula
  desc "ADAPTIVE Communication Environment: OO network programming in C++"
  homepage "https://www.dre.vanderbilt.edu/~schmidt/ACE.html"
  url "http://download.dre.vanderbilt.edu/previous_versions/ACE-6.4.1.tar.bz2"
  sha256 "4c74a30a1d013624a2426fd6e0a4791eca4ca8979065e52f7daebda7289dd23e"

  bottle do
    cellar :any
    sha256 "8b2594f8361cebeeb579ae2b0d3c678f5f003df9770e9c6ba679a418039ae4ab" => :sierra
    sha256 "32eaec9cc8f3ea718da715edd4bce363f84062c6bdaf2a23ef73398cbc5d2fe3" => :el_capitan
    sha256 "ac79623a4dde98b876be53fb97c4ed063309f77f5d0991a12e13b38fceb06c42" => :yosemite
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
