class Ace < Formula
  desc "ADAPTIVE Communication Environment: OO network programming in C++"
  homepage "https://www.dre.vanderbilt.edu/~schmidt/ACE.html"
  url "https://github.com/DOCGroup/ACE_TAO/releases/download/ACE%2BTAO-7_1_0/ACE+TAO-7.1.0.tar.bz2"
  sha256 "90d642b7a67445da89cb73d2c091b169b373c63d2db78cf498d930864b382d43"
  license "DOC"

  livecheck do
    url :stable
    regex(/^ACE(?:\+[A-Z]+)*?[._-]v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ada168b074673464c5df580586851bf63414bd1447829739244dd529de78ec4a"
    sha256 cellar: :any,                 arm64_monterey: "6b20bb02c83b23bad813484cf68af5a7d42e40622cc1788dbba342f22ff71f28"
    sha256 cellar: :any,                 arm64_big_sur:  "e33d6ba6e4d63ef217f556c8390f5aea972ab517880d2874a21551b09e436161"
    sha256 cellar: :any,                 ventura:        "93150d90ef5008ab881cc957f60155da40056ada9054ed52154ecf6934014843"
    sha256 cellar: :any,                 monterey:       "beb1ad000bb8185b740e972b23f8f7bc7bd447c6510f15039119cb4ca52c9e7e"
    sha256 cellar: :any,                 big_sur:        "a6ac07e8e75354975f1ed42bb8de2ca39bad8763da802fe2f455b99287b85408"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6abf9610d9d0a20d7b2d875d54648f985ca8c999523533ae5e426bd6976d300e"
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

    ENV.append "LDFLAGS", "-Wl,-rpath,#{lib}" if OS.mac?
    system "make", "-C", "examples/Log_Msg"
    pkgshare.install "examples"
  end

  test do
    cp_r "#{pkgshare}/examples/Log_Msg/.", testpath
    system "./test_callback"
  end
end
