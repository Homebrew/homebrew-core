class Ace < Formula
  desc "ADAPTIVE Communication Environment: OO network programming in C++"
  homepage "https://www.dre.vanderbilt.edu/~schmidt/ACE.html"
  url "http://download.dre.vanderbilt.edu/previous_versions/ACE-6.4.7.tar.bz2"
  sha256 "cda98024f0fab631a05c2b418177bf5a11dbcfb557010faf22ddf2397b6376fd"

  bottle do
    cellar :any
    sha256 "3b08576a20695765d2b0e6e81a1b21fda550684fcf858296ac37c5cefcb089eb" => :high_sierra
    sha256 "7c127700300f31972bc2679928d5e74ed7a8df88fd7903a4b0f95e56a8925afd" => :sierra
    sha256 "fce070f2db3bafd89234a1d655c15d71720401da6884559abee507f968b69e7c" => :el_capitan
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
