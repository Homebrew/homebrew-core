class Ace < Formula
  desc "ADAPTIVE Communication Environment: OO network programming in C++"
  homepage "https://www.dre.vanderbilt.edu/~schmidt/ACE.html"
  url "https://github.com/DOCGroup/ACE_TAO/releases/download/ACE%2BTAO-6_5_3/ACE-6.5.3.tar.bz2"
  sha256 "b1d6a716394bd15c21bb90037b8a12a4d8034cc9d8878b0ad39b3c467df19b1a"

  bottle do
    cellar :any
    sha256 "6317e052600f58fbf5babaff25d1547f4a60d9245c4d2f20b2abcb88d2be529b" => :mojave
    sha256 "b9d6560fa1f77ef0c2ed224358ff12c36d3bd891b324f7cf5cf25e8a9a964998" => :high_sierra
    sha256 "494295460a72b2985937c0b2d20d7fd4a7bb72d831aac56e6a3b29a06ae7eb50" => :sierra
    sha256 "7446d319c8112215c8b278252b59a91d96a19b89e914985a14973d371d73d6f1" => :el_capitan
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
