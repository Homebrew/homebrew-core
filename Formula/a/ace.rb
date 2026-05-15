class Ace < Formula
  desc "ADAPTIVE Communication Environment: OO network programming in C++"
  homepage "https://www.dre.vanderbilt.edu/~schmidt/ACE.html"
  url "https://github.com/DOCGroup/ACE_TAO/releases/download/ACE%2BTAO-8_0_6/ACE+TAO-8.0.6.tar.bz2"
  sha256 "3e76a8ffcfdac916859222f8abbd6617b47d07e9f5e419b1df2e201dcd0a875b"
  license "DOC"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^ACE(?:\+[A-Z]+)*?[._-]v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "25b8863e7a987bfd3cb0600fd0b03796543ac9117be55ef9418ff23439ac301a"
    sha256 cellar: :any,                 arm64_sequoia: "a8472c6240069903212f2d6510bbfea721fbf98d8b32929b0e3a6b018a4f18e7"
    sha256 cellar: :any,                 arm64_sonoma:  "1c8a43208bd191d3d99f0fd99123c69f4e726ab07b24fb065b2d31e89f2d6a64"
    sha256 cellar: :any,                 sonoma:        "430f1d9ae9a21b1b9fec6adc46952e04056ca250033d3972ddce64b6661c99b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99a2c06217a1da8b8fef9c72638669e355cd5443b0937d245868498ca8ebe9cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f7c1c5865d3faf699ed79c109fa3828aab4f08d0886619a02cb4d12d2ecdbab"
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
