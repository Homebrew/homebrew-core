class Ace < Formula
  desc "ADAPTIVE Communication Environment: OO network programming in C++"
  homepage "https://www.dre.vanderbilt.edu/~schmidt/ACE.html"
  url "http://download.dre.vanderbilt.edu/previous_versions/ACE-6.4.2.tar.bz2"
  sha256 "e334aa2f90e570c311d2c7cc18ca9908d682d86a537e358caadc01df1fdd4c37"

  bottle do
    cellar :any
    sha256 "3899536da0a018ce9989e55a6e2c23b3956e285921ebd0faf3749ba0c32054c9" => :sierra
    sha256 "eb4b3c216549cc92e43f0570ea7597f9042b33e252dcb14b0abecc254f0f8e2d" => :el_capitan
    sha256 "bed3ffe0bc9b805e5810c5fa4e9a2be0bf4b663ef6362278c29e10d7c1a72858" => :yosemite
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
