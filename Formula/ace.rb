class Ace < Formula
  desc "ADAPTIVE Communication Environment: OO network programming in C++"
  homepage "https://www.dre.vanderbilt.edu/~schmidt/ACE.html"
  url "http://download.dre.vanderbilt.edu/previous_versions/ACE-6.4.6.tar.bz2"
  sha256 "d263b2e0680ea24acd5ba05f8dbfdee0f4ceec18cf78fd5c09461750c4e46d77"

  bottle do
    cellar :any
    sha256 "8e546261101509e7b600f2cdf73451b606cc32bfecfe64d661f893bae6c1d756" => :high_sierra
    sha256 "a3ec66c4a8f0aa33bf8079240a0eecf510455fece517bf6f4f2f07f2c1f8d1f1" => :sierra
    sha256 "aa558003a97c0909a44adda0a0563a22e1a6bb6c560c15a656c545c19deb6701" => :el_capitan
    sha256 "6fd93f3a1aecfa2861526ba41ff2998ca791e2668decffae36c2fa01db61b032" => :yosemite
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
