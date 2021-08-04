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
    sha256 cellar: :any, big_sur:  "e775c13231df144b96eb5b8ccb4cc41820d3dacc7b2fb992f3f23c9556475fc2"
    sha256 cellar: :any, catalina: "5017da50a43bb401aa77a4d7341d3bce1716e01309e037940270b68e22d0c639"
    sha256 cellar: :any, mojave:   "c58f59f7f8fa56d725c2563dc0e121eb64912be9c5df9ce1b2e8104c26d4c042"
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
