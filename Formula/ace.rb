class Ace < Formula
  desc "ADAPTIVE Communication Environment: OO network programming in C++"
  homepage "https://www.dre.vanderbilt.edu/~schmidt/ACE.html"
  url "https://github.com/DOCGroup/ACE_TAO/releases/download/ACE%2BTAO-7_1_0/ACE+TAO-7.1.0.tar.bz2"
  sha256 "90d642b7a67445da89cb73d2c091b169b373c63d2db78cf498d930864b382d43"
  license "DOC"

  livecheck do
    url :stable
    regex(/^ACE(?:\+[A-Z]+)*?[._-]v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a44e54f72c986ac00a0d69f0c29d4210c15a8e388633f048572a61a72e8f08ec"
    sha256 cellar: :any,                 arm64_monterey: "70de46a1f01f56b30aeb025c6e614ffcc5b57fc1b8ab75ec9977ba6ccdd949bb"
    sha256 cellar: :any,                 arm64_big_sur:  "74c0543862954a143e3c416b3882212b6236bc4f57d16083921926410923ee35"
    sha256 cellar: :any,                 ventura:        "194c265bb2c944f55f6d2b25b7b3a027ab77c8991d3466f274af458db1f11d57"
    sha256 cellar: :any,                 monterey:       "2d5398e1c4eb90a7bb2c23803f3e45d91f13ec9378550660da9ce3500f17c1a3"
    sha256 cellar: :any,                 big_sur:        "3a81bf75bfec8c9f4f0d867e6eb94b50bbbff0a8b2ee4ce26e5824f11ec37cad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2c94b653f0d51707ea554fd420d64fc12455bf8142d19aaedf41ccfb2f1a422"
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
