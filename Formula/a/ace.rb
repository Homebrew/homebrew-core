class Ace < Formula
  desc "ADAPTIVE Communication Environment: OO network programming in C++"
  homepage "https://www.dre.vanderbilt.edu/~schmidt/ACE.html"
  url "https://github.com/DOCGroup/ACE_TAO/releases/download/ACE%2BTAO-7_1_4/ACE+TAO-7.1.4.tar.bz2"
  sha256 "1d2cedfb3726bb93a04e097573bb7b840849a922161bc2075973d50935c7c4f6"
  license "DOC"

  livecheck do
    url :stable
    regex(/^ACE(?:\+[A-Z]+)*?[._-]v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "23bf3e3369c31a1a091f21a4ae0616c9766d24fe80c22c382c31ccc2ad05fd5b"
    sha256 cellar: :any,                 arm64_ventura:  "6160d76088608db480cfbcd6789d3c5fbbe64cecc5453e23f8f8ee994cf4c9bb"
    sha256 cellar: :any,                 arm64_monterey: "cfe86f5366472ea181c67f12b22e81ab5d7af1e7d8b323db0c0caa1eebdcae6a"
    sha256 cellar: :any,                 sonoma:         "95440d175556c12584d81c191fee8831b00480da7d893144bb0db738b8bff5d3"
    sha256 cellar: :any,                 ventura:        "458b1587d0d88b602d65042ca99f0345b615eb07b8ea641b68c0de29081d2bc5"
    sha256 cellar: :any,                 monterey:       "82e137faffbbc08487414aa7521ce55a7a5436193f49815e0b6e6cf51d868346"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ee81e6d3a4af23944fdf77a65cdd671b014d5d3b7c6731cd052f4e804802ffd"
  end

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
