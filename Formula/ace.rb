class Ace < Formula
  desc "ADAPTIVE Communication Environment: OO network programming in C++"
  homepage "https://www.dre.vanderbilt.edu/~schmidt/ACE.html"
  url "http://download.dre.vanderbilt.edu/previous_versions/ACE-6.4.7.tar.bz2"
  sha256 "cda98024f0fab631a05c2b418177bf5a11dbcfb557010faf22ddf2397b6376fd"

  bottle do
    cellar :any
    sha256 "ed3ef2c7bd2a488b532e818b9af4dd27a84f82ed3176a6512f3264f74f149ab7" => :high_sierra
    sha256 "96cee7cfac8bf6a32ff2e9791a7d19828fe607813c9c9b7c065d42ae496655ef" => :sierra
    sha256 "aca5e697853ca50b40397224d80f3eae66a2011f9682b0fd980cbec6d227ebbd" => :el_capitan
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
