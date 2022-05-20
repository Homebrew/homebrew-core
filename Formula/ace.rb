class Ace < Formula
  desc "ADAPTIVE Communication Environment: OO network programming in C++"
  homepage "https://www.dre.vanderbilt.edu/~schmidt/ACE.html"
  url "https://github.com/DOCGroup/ACE_TAO/releases/download/ACE%2BTAO-7_0_6/ACE+TAO-7.0.6.tar.bz2"
  sha256 "27990ce2d17f5811efd589fa3de7c77e25e2dc33b3a6bfbe1b9f439eedd2dc3c"
  license "DOC"

  livecheck do
    url :stable
    regex(/^ACE(?:\+[A-Z]+)*?[._-]v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 monterey:     "bd09d99803ce5e5671cfd4e369f6bf6b04294e7c72676c23df912ab2f7fce19f"
    sha256 cellar: :any,                 big_sur:      "dc143404b04e701aad213768a9b58187e5f1b17feb3941aa2467aa0aa0cad672"
    sha256 cellar: :any,                 catalina:     "737f43fe9b5a430161f71b80ad1955c6ca9ef39ec93b7542e373e469f124c3e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9f606ddfb06aa69c55edb6365e75b4db570a966cf8c48382f5466d5734bcea5c"
  end

  def install
    os = OS.mac? ? "macosx" : "linux"
    ln_sf "config-#{os}.h", "ace/config.h"
    ln_sf "platform_#{os}.GNU", "include/makeinclude/platform_macros.GNU"

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

    system "make", "-C", "examples/Log_Msg"
    pkgshare.install "examples"
  end

  test do
    cp_r "#{pkgshare}/examples/Log_Msg/.", testpath
    system "./test_callback"
  end
end
