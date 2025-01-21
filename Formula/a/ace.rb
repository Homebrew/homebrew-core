class Ace < Formula
  desc "ADAPTIVE Communication Environment: OO network programming in C++"
  homepage "https://www.dre.vanderbilt.edu/~schmidt/ACE.html"
  url "https://github.com/DOCGroup/ACE_TAO/releases/download/ACE%2BTAO-8_0_2/ACE+TAO-8.0.2.tar.bz2"
  sha256 "c6ea38778715f7bb76d7702ad299571445f3fa55b429a82e31c14a4c6709fe87"
  license "DOC"

  livecheck do
    url :stable
    regex(/^ACE(?:\+[A-Z]+)*?[._-]v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a53c1b29de9f6b49758ed5c34f607e26152d2c95c5dca17f07b22c55a1f02e95"
    sha256 cellar: :any,                 arm64_sonoma:  "75b5340ebcbd4626e4f3c2bd286b4fa5177f1888065799d6940d826624257ea0"
    sha256 cellar: :any,                 arm64_ventura: "061ee45140a58788634768a0a739b6894f65d02b24931a26a98bc7bd1299b67e"
    sha256 cellar: :any,                 sonoma:        "491988bd9822fbfbfe5f2c146e5d63500d6873c2bd2bd497fd71664b3294b8e2"
    sha256 cellar: :any,                 ventura:       "f4558dd66ed0d9f543b7b50981718240f5bf2f1d9cd81d7b60793460aa8db7b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9eed58bb778245048efeb746d1b3739c237c4b1e38cde199ab7a9fd0d71dedc7"
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
