class Ace < Formula
  desc "ADAPTIVE Communication Environment: OO network programming in C++"
  homepage "https://www.dre.vanderbilt.edu/~schmidt/ACE.html"
  url "http://download.dre.vanderbilt.edu/previous_versions/ACE-6.5.0.tar.bz2"
  sha256 "dbfbb6b7747de2c5de101403b1ccd7b673ea5a31e7492504467070b98ef5f357"

  bottle do
    cellar :any
    sha256 "21f2d6566dddbd11c6d74d5f7afd6636c3fbf39a8f652e2de8843f46f9b193db" => :high_sierra
    sha256 "200e8d6a25948571de99c4ec163357e790e5450b4293161659260f8ca259324f" => :sierra
    sha256 "6c6b235b55090f49aa237599e01b325bdfb84585f232b4ff78f28b616f3ec290" => :el_capitan
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
