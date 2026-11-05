class Chicken < Formula
  desc "Compiler for the Scheme programming language"
  homepage "https://www.call-cc.org/"
  url "https://code.call-cc.org/releases/6.1.0/chicken-6.1.0.tar.gz"
  sha256 "c6aee9a5374102ba318e0cfae62ded5e1825346577137952d7fb15b3094d49d8"
  license "BSD-3-Clause"
  head "https://code.call-cc.org/git/chicken-core.git", branch: "master"

  livecheck do
    url "https://code.call-cc.org/releases/current/"
    regex(/href=.*?chicken[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "0be5053995955c0b6cf1758ecc3235be6aa31e00e35650f30f9153c80fafb958"
    sha256 arm64_tahoe:       "b0c4a636b36039f80d5fed3507de11fea9259807e90868168d68621576d43ae9"
    sha256 arm64_sequoia:     "e35d8a7e579f006257e4b10932c19034e9b1629b23a923ae9fcb3682d522f72f"
    sha256 arm64_linux:       "3747d49517df2252d3b0d8d6e094283477e5a3361bcb117083b8db7533773860"
    sha256 x86_64_linux:      "046ed1ca1a2c3134b600e12488c76afc1cfa229aa4f137e81c7fcf6630bd250c"
  end

  conflicts_with "mono", because: "both install `csc`, `csi` binaries"

  deny_network_access!

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
