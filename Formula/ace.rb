class Ace < Formula
  desc "ADAPTIVE Communication Environment: OO network programming in C++"
  homepage "https://www.dre.vanderbilt.edu/~schmidt/ACE.html"
  url "https://github.com/DOCGroup/ACE_TAO/releases/download/ACE%2BTAO-7_0_3/ACE-7.0.3.tar.bz2"
  sha256 "68a4b12982763a6c420c7c01adf50c7a74fd2d8cc5607e4fdd1f2afd086433e7"
  license "DOC"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/ACE(?:%2B[A-Z]+)*?[._-]v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any, big_sur:  "bdd856d91186406ba290bbf4b31ad75a6c3452149b15272d378c76c99e51e66a"
    sha256 cellar: :any, catalina: "a831aa6f9782156d4cbfb448bb040d5022176e122c7376d4fe83c7f409a4d5a9"
    sha256 cellar: :any, mojave:   "19b845b6dffcae5d3949c28af0157a5e11983cd48a4ee33bd7b18145321186a1"
  end

  def install
    ln_sf "config-macosx.h", "ace/config.h"
    ln_sf "platform_macosx.GNU", "include/makeinclude/platform_macros.GNU"

    # Set up the environment the way ACE expects during build.
    ENV.cxx11
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
