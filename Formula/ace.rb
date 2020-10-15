class Ace < Formula
  desc "ADAPTIVE Communication Environment: OO network programming in C++"
  homepage "https://www.dre.vanderbilt.edu/~schmidt/ACE.html"
  url "https://github.com/DOCGroup/ACE_TAO/releases/download/ACE%2BTAO-6_5_11/ACE-6.5.11.tar.bz2"
  sha256 "8bfa251186d9ed1ce48d8936bdace4bc11a49f5fa216f8c1d0be7a65bcf66b39"
  license "DOC"

  bottle do
    cellar :any
    sha256 "3b5f8677da8a76ce379d757e8a79f9767c71526054b956357220fbd083d862da" => :catalina
    sha256 "65480c8e969c73974cb580b967d62799802ca0d4036cb070ccf2f022c8ef50d6" => :mojave
    sha256 "04a4e84d9ac91a24d10db2223a278dbbfe665901bdd5227b2ee0c991a0de1fd6" => :high_sierra
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
