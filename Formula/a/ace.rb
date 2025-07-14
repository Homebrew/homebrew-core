class Ace < Formula
  desc "ADAPTIVE Communication Environment: OO network programming in C++"
  homepage "https://www.dre.vanderbilt.edu/~schmidt/ACE.html"
  url "https://github.com/DOCGroup/ACE_TAO/releases/download/ACE%2BTAO-8_0_4/ACE+TAO-8.0.4.tar.bz2"
  sha256 "025f6bf99a7629d52b47aa5f2e023d2a14280c1c5330bdc660230778081dc0e3"
  license "DOC"

  livecheck do
    url :stable
    regex(/^ACE(?:\+[A-Z]+)*?[._-]v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b0d97fc3d70cc2dbb5f52f151b744c6e78a650c78becb6f752c872f61728a027"
    sha256 cellar: :any,                 arm64_sonoma:  "1467891ce91f3cc5de68983f31e4f7c07aab2ea1af9501f9afcdc5576acb3694"
    sha256 cellar: :any,                 arm64_ventura: "afaabd50fe955b796b1a8f3574323a27a88de790145ac47299860699fcdb0264"
    sha256 cellar: :any,                 sonoma:        "412f48e7f56c411f9662b1591ed19a6e6e53fb4df3333861d09a0a117fa76aa7"
    sha256 cellar: :any,                 ventura:       "a5e1325c2062b6502fb480e2631af4c4a6664570aac32ecbe1903de24184fd8e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "526b702ecbbcb663952ba3934a95657d5a69f59b0e22f20b51c85cccb0e24ba9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eff225a6701ee155fb016b7b42569b20307d950a5f1a6654d360669465b9000c"
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
