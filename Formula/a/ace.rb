class Ace < Formula
  desc "ADAPTIVE Communication Environment: OO network programming in C++"
  homepage "https://www.dre.vanderbilt.edu/~schmidt/ACE.html"
  url "https://github.com/DOCGroup/ACE_TAO/releases/download/ACE%2BTAO-8_0_1/ACE+TAO-8.0.1.tar.bz2"
  sha256 "2940b7c73a6f100e733b8eb35315509e1340781f08c756eb64cef262998c8849"
  license "DOC"

  livecheck do
    url :stable
    regex(/^ACE(?:\+[A-Z]+)*?[._-]v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "e10a2e57e6d68c6b6e1e8e47b13864562ce59a4afd0886aba8a7f6910492328a"
    sha256 cellar: :any,                 arm64_sonoma:   "95324bd849e938e8ffa9c69fe08eb1e3c57838c26baabe14674f38a55a02ca20"
    sha256 cellar: :any,                 arm64_ventura:  "f225810e91d4085913245f0210800d7ae92a2d8894db52facbd1dd6be9187ec8"
    sha256 cellar: :any,                 arm64_monterey: "16afa166a37efc1f4e2370c509895b3ac681224c342fe1a28ef069d766afd726"
    sha256 cellar: :any,                 sonoma:         "ef7379a595663c725e5a8f39045423e23d2f866687067afb27d6dd8ef27bd397"
    sha256 cellar: :any,                 ventura:        "a797074bd595eb2c85c3df21175cbe435eef470e4f3feaa07166cb77248ef9f7"
    sha256 cellar: :any,                 monterey:       "85ddc8f3ad06ae8848a3713f0ad3762c4f5ed06a95c8f7723d21ebe7b4966e3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc1d135b4369783a6d3e02ae50acc63f2738e57befe4ee407b47ce30b1fd6e15"
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
