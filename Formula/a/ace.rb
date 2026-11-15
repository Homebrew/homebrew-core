class Ace < Formula
  desc "ADAPTIVE Communication Environment: OO network programming in C++"
  homepage "https://www.dre.vanderbilt.edu/~schmidt/ACE.html"
  url "https://github.com/DOCGroup/ACE_TAO/releases/download/ACE%2BTAO-8_0_8/ACE+TAO-8.0.8.tar.bz2"
  sha256 "d7b1d3e1534095b0a627817f4472eed1cc27ccf83fd011557031cf073fc7222a"
  license "DOC"
  compatibility_version 3

  livecheck do
    url :stable
    regex(/^ACE(?:\+[A-Z]+)*?[._-]v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "285859dbe41ddeef30775f0439be848fa4e2d48679656be0251552bf7de44b08"
    sha256 cellar: :any, arm64_tahoe:       "2d77ce8098c09ad168bf5448ee8640200e0313bb3603fbf047fb37403b82f820"
    sha256 cellar: :any, arm64_sequoia:     "5aa502f337d40bcbea1a0b9a47bddf659c35a28caf1f328512d13a323ff5292c"
    sha256 cellar: :any, arm64_linux:       "fad05cfb26e5345a9a3a7a85934bc2844dbe6d51a171f1f22fea38998fdd853b"
    sha256 cellar: :any, x86_64_linux:      "58d04e9b8c3407be1950519ec717442a73dcc4699a59488315c3444f86f76caa"
  end

  deny_network_access!

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
