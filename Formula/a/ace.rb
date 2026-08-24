class Ace < Formula
  desc "ADAPTIVE Communication Environment: OO network programming in C++"
  homepage "https://www.dre.vanderbilt.edu/~schmidt/ACE.html"
  url "https://github.com/DOCGroup/ACE_TAO/releases/download/ACE%2BTAO-8_0_7/ACE+TAO-8.0.7.tar.bz2"
  sha256 "d61aa5de71a3e1bee09f74a0ff5f1309f09d4af9dd9ee4804483af4cf7cf7495"
  license "DOC"
  compatibility_version 2

  livecheck do
    url :stable
    regex(/^ACE(?:\+[A-Z]+)*?[._-]v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3453c98056d85c2cf90b11dbfc669a5adf6db896c2901fa30bf11ee59462663d"
    sha256 cellar: :any, arm64_sequoia: "5f1ddaf95f1d5c1e971d6645ec3a8e7da275bce35b305d63b69b74604b80c858"
    sha256 cellar: :any, arm64_sonoma:  "a2ba34e3ba971e8b4c34975ab7f74a9f97557cc53d677ce6f3b754010db5d2a8"
    sha256 cellar: :any, sonoma:        "b898fb146aa7ec753ef78cc31c0200b0570877bbf536ee69a5c9a55d61d5032b"
    sha256 cellar: :any, arm64_linux:   "49a726138235af2706cdedb773e4e15c29ca6264cbbd389eec46ccffcb0a6df3"
    sha256 cellar: :any, x86_64_linux:  "7fe0511e2d8e4c71b60a0b9416ba7fa47ba932a8c099758d424f3ac6cf3750d3"
  end

  deny_network_access!

  def install
    os = OS.mac? ? "macosx" : "linux"
    ln_sf "config-#{os}.h", "ace/config.h"
    ln_sf "platform_#{os}.GNU", "include/makeinclude/platform_macros.GNU"

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

    ENV.append "LDFLAGS", "-Wl,-rpath,#{lib}" if OS.mac?
    system "make", "-C", "examples/Log_Msg"
    pkgshare.install "examples"
  end

  test do
    cp_r "#{pkgshare}/examples/Log_Msg/.", testpath
    system "./test_callback"
  end
end
