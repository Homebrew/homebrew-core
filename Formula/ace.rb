class Ace < Formula
  desc "ADAPTIVE Communication Environment: OO network programming in C++"
  homepage "https://www.dre.vanderbilt.edu/~schmidt/ACE.html"
  url "http://download.dre.vanderbilt.edu/previous_versions/ACE-6.4.5.tar.bz2"
  sha256 "004198f7a07fc2938986399d654547ff3811936b16202fdab59b3beb365dd82f"

  bottle do
    cellar :any
    sha256 "19c80cbb29f33edcbcb625c57741f3200b40289a511f17228fab6e6258c8eb80" => :sierra
    sha256 "89da44bd204d9ca1fbd4d93f9e90fae4785557507228f16ba2d50a8e37fd48d7" => :el_capitan
    sha256 "4d24253c4e350eefad30e21ea06fc893f7021d55e6b4a29ed41a009e67b70734" => :yosemite
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
