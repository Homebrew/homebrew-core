class Ace < Formula
  desc "ADAPTIVE Communication Environment: OO network programming in C++"
  homepage "https://www.dre.vanderbilt.edu/~schmidt/ACE.html"
  url "https://github.com/DOCGroup/ACE_TAO/releases/download/ACE%2BTAO-7_0_4/ACE-7.0.4.tar.bz2"
  sha256 "9f2fc1f51e6b988cbf7eea0974e901a64706089325a836e3cff5ac7ed1ff30ba"
  license "DOC"

  livecheck do
    url :stable
    regex(/^ACE(?:\+[A-Z]+)*?[._-]v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any, big_sur:  "181d76fe2e542768e2013e7f9464bb0bbb90e91bd2e64ba76f7ad818e00694d0"
    sha256 cellar: :any, catalina: "4d017e76911e017c72ad42ea08ea29fb02bb17eb7a2a733bde4957fb51009f01"
    sha256 cellar: :any, mojave:   "5d0805c7e78dbbf09a154b43e8613d167aa6f3a367e55a60299dec65d933cff9"
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
