class Ace < Formula
  desc "ADAPTIVE Communication Environment: OO network programming in C++"
  homepage "https://www.dre.vanderbilt.edu/~schmidt/ACE.html"
  url "https://github.com/DOCGroup/ACE_TAO/releases/download/ACE%2BTAO-8_0_5/ACE+TAO-8.0.5.tar.bz2"
  sha256 "1f539d4be5a50791ea45d53f0aa71eb07383a12715c7f56487318172ab48d743"
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
    sha256 cellar: :any,                 arm64_tahoe:   "723cf89b58d2a47670cd669057004a59a38969aeb94e73710d95f3ba7db75876"
    sha256 cellar: :any,                 arm64_sequoia: "d341e47e245341bf21821888a94c2fba6882f9fc08109bde313b196cd5a2980d"
    sha256 cellar: :any,                 arm64_sonoma:  "4278aadca8ec160df5b9a7767cb846260dbc8cbe34191f6194100cf9216c5a57"
    sha256 cellar: :any,                 arm64_ventura: "60335363ff4ce8c51f6463ce517993522f751d830d3ec7f3afc1eeee726d3455"
    sha256 cellar: :any,                 sonoma:        "6f746eb61a1f47f3bafc23f51d5f45ef2833e6aac7fee4ac2f6fecd7fb0464a2"
    sha256 cellar: :any,                 ventura:       "86573e39966f22e0b8f0ac7fb2496737b97c65e06caff805cd2d5872ed80f33b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b2e800d881a976ecf0882c2d3d5de3fffd5a6e777770ae4f5e6cedc651ee7a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32e0c9ff8192c7d4165d88e3cf86663de57f33b18d76ca0d76ed0e8dfe7eda68"
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
