class Ace < Formula
  desc "ADAPTIVE Communication Environment: OO network programming in C++"
  homepage "https://www.dre.vanderbilt.edu/~schmidt/ACE.html"
  url "https://github.com/DOCGroup/ACE_TAO/releases/download/ACE%2BTAO-6_5_10/ACE-6.5.10.tar.bz2"
  sha256 "90de437926928e98e9fd9132c7c3e886ca79f25567adeccbc24a5996f230d8e2"

  bottle do
    cellar :any
    sha256 "b927c8d220e8bae7f821842f12918913ff39fbf42d8dd19ac0f304fcaf7c726f" => :catalina
    sha256 "b25da938944f8204721e41a580321d3fd61576aac0d62b542deae5a3b23478d8" => :mojave
    sha256 "6f41f8fa3975be36a2263e8e49ebd3d9a7ab0b1e575035434353b5be0f1ff1ff" => :high_sierra
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
