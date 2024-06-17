class Ace < Formula
  desc "ADAPTIVE Communication Environment: OO network programming in C++"
  homepage "https://www.dre.vanderbilt.edu/~schmidt/ACE.html"
  url "https://github.com/DOCGroup/ACE_TAO/releases/download/ACE%2BTAO-8_0_0/ACE+TAO-8.0.0.tar.bz2"
  sha256 "dc49e7e4b3116fcb57ccbb187ed2480184d54e62269057e4f22c76078b4969c3"
  license "DOC"

  livecheck do
    url :stable
    regex(/^ACE(?:\+[A-Z]+)*?[._-]v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ac9c7e43ccb61d15d93548aca81fa333c0dc142b55f860dd638ffc8e399d9b18"
    sha256 cellar: :any,                 arm64_ventura:  "bdaec0419bfd90395dccd4cd33c0f5351e8238531b261b24761f95dc386343cf"
    sha256 cellar: :any,                 arm64_monterey: "6e5819bbd942acbdf4840586c90d25dbfc28c656f495c490ccb6ba6d99be12e7"
    sha256 cellar: :any,                 sonoma:         "adf3900bd19645c123da4d28ea0801bdb66df39eeaf0bba1b1604c0dab3b9a2d"
    sha256 cellar: :any,                 ventura:        "25cc9c8513e6f06767be9ec8f5e3ba29168e580549777904ad65bf9c2607c744"
    sha256 cellar: :any,                 monterey:       "257bcbe9063e065718dc17fa3f17ae5aed4e88bbf025567dae373ab92218c32c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "164697b83486f3e168d8f5fc5f77d153e591badef94ae74ce75b6ac27b8c6504"
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
