class Ace < Formula
  desc "ADAPTIVE Communication Environment: OO network programming in C++"
  homepage "https://www.dre.vanderbilt.edu/~schmidt/ACE.html"
  url "https://github.com/DOCGroup/ACE_TAO/releases/download/ACE%2BTAO-7_1_1/ACE+TAO-7.1.1.tar.bz2"
  sha256 "cfcc4fee4a9875224f2a847dbb1d4e09df8446311311036d346b6373e3439d8b"
  license "DOC"

  livecheck do
    url :stable
    regex(/^ACE(?:\+[A-Z]+)*?[._-]v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "908c990507cb957da3d30b35a84de3265c6ec726a710984c506260afab221634"
    sha256 cellar: :any,                 arm64_monterey: "dc660ba8b021a08a64513ba724342dd3e0535d66715fa429f32b4a8ae5be869e"
    sha256 cellar: :any,                 arm64_big_sur:  "36c13f42ac4c2802db195a7fe6ab5fd6a57b64ce5610662b00ea81bc31a32051"
    sha256 cellar: :any,                 ventura:        "094c6cb6e9696e8ef8ad2f4c101584dc283515263162e32c0f1fa8618e1fb09c"
    sha256 cellar: :any,                 monterey:       "1eb509ad6ff9cb45929683fe2297c09d6cb3ae428bd4d5abfa4aa275d6dbf1fc"
    sha256 cellar: :any,                 big_sur:        "16280055ab1dd1cebecddb1f89eac455765061ce04cfab7618b82e2c6dd50ebb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01ef8de1c51d1ada01aa8fadf4e9231545493460a609175e2c6601e7870d760c"
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
