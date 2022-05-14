class Chicken < Formula
  desc "Compiler for the Scheme programming language"
  homepage "https://www.call-cc.org/"
  url "https://code.call-cc.org/releases/5.3.0/chicken-5.3.0.tar.gz"
  sha256 "c3ad99d8f9e17ed810912ef981ac3b0c2e2f46fb0ecc033b5c3b6dca1bdb0d76"
  license "BSD-3-Clause"
  revision 1
  head "https://code.call-cc.org/git/chicken-core.git", branch: "master"

  livecheck do
    url "https://code.call-cc.org/releases/current/"
    regex(/href=.*?chicken[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "e09430040963225492897d7609406819e86fb849d13845ad8087d5d61e31eaca"
    sha256 arm64_big_sur:  "61ae526015573afb8c25f406a65cdd4b7de3f8eb937e4f7fa6e7348323d89898"
    sha256 monterey:       "049d9b3aa4cd14369f60989ab423da0b73a1aeab96b15e3c238f904de0293fb0"
    sha256 big_sur:        "86b3c43930711b19e3270bda4701c3472da23eed410ca33203426e155f7098ff"
    sha256 catalina:       "6cc05c82270f15d1013cd4d3d63ed7b82ae891c29ff6fc3156be89c3d64973f1"
    sha256 x86_64_linux:   "cb961e4d3aadeca9ffff40761b866ba766234d9b4ffe87cf4daae445435f5e4d"
  end

  def install
    ENV.deparallelize

    args = %W[
      PREFIX=#{prefix}
      C_COMPILER=#{ENV.cc}
      LIBRARIAN=ar
      ARCH=#{Hardware::CPU.arch.to_s.tr("_", "-")}
      LINKER_OPTIONS=-Wl,-rpath,#{rpath},-rpath,#{HOMEBREW_PREFIX}/lib
    ]

    if OS.mac?
      args << "POSTINSTALL_PROGRAM=install_name_tool"
      args << "PLATFORM=macosx"
    else
      args << "PLATFORM=linux"
    end

    system "make", *args
    system "make", "install", *args
  end

  test do
    assert_equal "25", shell_output("#{bin}/csi -e '(print (* 5 5))'").strip
    system bin/"csi", "-ne", "(import (chicken tcp))"
  end
end
