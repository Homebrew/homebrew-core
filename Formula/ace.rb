class Ace < Formula
  desc "ADAPTIVE Communication Environment: OO network programming in C++"
  homepage "https://www.dre.vanderbilt.edu/~schmidt/ACE.html"
  url "https://github.com/DOCGroup/ACE_TAO/releases/download/ACE%2BTAO-7_0_10/ACE+TAO-7.0.10.tar.bz2"
  sha256 "cba005e2d267884ba9634414bd39c2a72b8717eb9f7a7a293298f3b2a05c841e"
  license "DOC"

  livecheck do
    url :stable
    regex(/^ACE(?:\+[A-Z]+)*?[._-]v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cfa80b485f1d51d1eb09d60d7df7d5ffce40351a0197ae21dc8db39e8504f2af"
    sha256 cellar: :any,                 arm64_monterey: "60fd82a1971945ab538e4d046be59667b36ff54939dd589212b7589f781841f9"
    sha256 cellar: :any,                 arm64_big_sur:  "95d068587e3b225c2e89f6c5eb3ee90392e668016a3fd9d64bbae5b2e8536fbb"
    sha256 cellar: :any,                 monterey:       "949e91832d66f4847962b442b432bb65d38e9684e9356a4b71ec7fbe242ede68"
    sha256 cellar: :any,                 big_sur:        "4aff94f9451f642832fbd149f3ce46f478ff3a551cda1c21a5ef950ef52a5281"
    sha256 cellar: :any,                 catalina:       "05cd85dccaae52ac12fb0451b3eac1d989bee1939d45cb9676b96cee8823356b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88910f3b96b2d1636dbf299aa48dafa7cabf3858f6d6a9d6262bcc6b8490e516"
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
