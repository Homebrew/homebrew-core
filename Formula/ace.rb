class Ace < Formula
  desc "ADAPTIVE Communication Environment: OO network programming in C++"
  homepage "https://www.dre.vanderbilt.edu/~schmidt/ACE.html"
  url "https://github.com/DOCGroup/ACE_TAO/releases/download/ACE%2BTAO-7_0_9/ACE+TAO-7.0.9.tar.bz2"
  sha256 "b0529b1e88df269b0382e84814b7e90d4d1fac6ca4e494e7282fd701140f30d2"
  license "DOC"

  livecheck do
    url :stable
    regex(/^ACE(?:\+[A-Z]+)*?[._-]v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1d7cdca57f5f17952a4fec4c8256bd12c3253334f8f33ff0e44085e822c37ba3"
    sha256 cellar: :any,                 arm64_big_sur:  "80bf0478c8a50658d45af23dfc60407435386952670cd1d0fd4dc7db44a2f390"
    sha256 cellar: :any,                 monterey:       "91e1921808d72dd92c2105909a32ec012777a3b4cc01c50e422169a4c2965e3e"
    sha256 cellar: :any,                 big_sur:        "59e10285e1f0cea510ce248000dcc1dce05d6962778f549f74efcdaa6550024a"
    sha256 cellar: :any,                 catalina:       "075c33922ec132c7cd0941e80f7e593a4fb48b3b9e163745fdba7734e0d88e29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fec7514588fe20d0c3150f9b935ce84925be69cd7de9e21857e658d862df0026"
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
