class Ace < Formula
  desc "ADAPTIVE Communication Environment: OO network programming in C++"
  homepage "https://www.dre.vanderbilt.edu/~schmidt/ACE.html"
  url "https://github.com/DOCGroup/ACE_TAO/releases/download/ACE%2BTAO-7_0_7/ACE+TAO-7.0.7.tar.bz2"
  sha256 "13f010e2de296a9d1f956c7f36795fec08991be500456bdb2cbc93a5503992e0"
  license "DOC"

  livecheck do
    url :stable
    regex(/^ACE(?:\+[A-Z]+)*?[._-]v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0c0fa199623f23e5d9e5a09ae081e3f1cd78439770241cec938557aa8db06a5a"
    sha256 cellar: :any,                 arm64_big_sur:  "149ac16c7371878bab16ba56c22352d95b288f9f0c39db8623532c410bcd7a16"
    sha256 cellar: :any,                 monterey:       "1e99a20e04ca3aa6b41e039fb67812c9e0bfe00be3aa1c96214f70a9272324bb"
    sha256 cellar: :any,                 big_sur:        "cf38ce7bbfe65861ceeb62b9c7918508d98eb9af015508cb09824e5d53de8e0f"
    sha256 cellar: :any,                 catalina:       "af1d41dadd07165268cccac71a7aa3c2739dab11b3f9365c0cf3eece75222716"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de249b9548f120b91cc3189106be8a8bb5c67f8207b76be8fb49470ecad00883"
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
