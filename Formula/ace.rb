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
    sha256 cellar: :any,                 arm64_monterey: "fe7c6e61e7c947cb7d1626a581a0a11f100e7e4e935d863b10afb1c85ec18a3a"
    sha256 cellar: :any,                 arm64_big_sur:  "205b9d903c71044a65b1071c942f8e3ceef024e1c8ce3a016aec987e5ea04e0f"
    sha256 cellar: :any,                 monterey:       "415484c2ad190e3f2afc6a018816103d2d1d61db9d5841da29608b86982f3964"
    sha256 cellar: :any,                 big_sur:        "e68787163e9490839158073a727d3b7ec7961b3db372b419498e0b1fc850efe2"
    sha256 cellar: :any,                 catalina:       "aa24069cba01f0a4eb58a99187fd728d3fcc434aac691150e50b1dfb20c3496b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0559274f11d5337a11faa54384ab48b6bd287b1071d60a51daf0bf105c0da394"
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
