class Ace < Formula
  desc "ADAPTIVE Communication Environment: OO network programming in C++"
  homepage "https://www.dre.vanderbilt.edu/~schmidt/ACE.html"
  url "https://github.com/DOCGroup/ACE_TAO/releases/download/ACE%2BTAO-7_1_3/ACE+TAO-7.1.3.tar.bz2"
  sha256 "46bb2118f10fe27cb5151bf72695c6bbd67e5e840f6bd8be463ee2f5f464b279"
  license "DOC"

  livecheck do
    url :stable
    regex(/^ACE(?:\+[A-Z]+)*?[._-]v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "940b5990038de3613fd856dccde38cd16a29127477f0fc9771f12d2401067309"
    sha256 cellar: :any,                 arm64_ventura:  "bf20918b3d2787ef8d008e679485cb0f5b156c3ca15fe71f93f7a2d164e365e2"
    sha256 cellar: :any,                 arm64_monterey: "a77f87a6f5e332f25c4333831ec1843e9107ec94f6631010cceab60afa2e218f"
    sha256 cellar: :any,                 sonoma:         "beb7eaf9114c617393b5c857c98abf4deefe203616178e3345e0eb3e3d9dff83"
    sha256 cellar: :any,                 ventura:        "2d8ff245c4b1bbce680b1d871eee3ad1f43161d5fa6ba433e8f7ec68b6b5ed9f"
    sha256 cellar: :any,                 monterey:       "b7f2f1233f6202517dc5e58eb8ce43eb298e0f4255f206cf9320eb89c00962d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a405b53cd8d0c559a74f4622dba8ee1e2ce12ada59d46f741a0326297ebc7e37"
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
