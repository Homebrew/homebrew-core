class Chicken < Formula
  desc "Compiler for the Scheme programming language"
  homepage "https://www.call-cc.org/"
  url "https://code.call-cc.org/releases/6.0.0/chicken-6.0.0.tar.gz"
  sha256 "92835552b1b687ad26737e429b5aba36510bf429f8816ec0f6d336c8cb41f443"
  license "BSD-3-Clause"
  head "https://code.call-cc.org/git/chicken-core.git", branch: "master"

  livecheck do
    url "https://code.call-cc.org/releases/current/"
    regex(/href=.*?chicken[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "222f71803ccab1a36dd1db93e11a63e5ff54917098c6a2826dfe46efb21196f7"
    sha256 arm64_sequoia: "9302cc0087855d5915caec5ec30d7975a5b0e3c43ff9048d0efcca1414aa3e0e"
    sha256 arm64_sonoma:  "3afeb2650c8f0108ce3a60bc5e4b1f6f4c1ea9f95a819b991e39edee5573ee40"
    sha256 sonoma:        "3c33a164c6540c353475e0629771be3be03dc22415623aec54b8c401a3a3c8a3"
    sha256 arm64_linux:   "09de34b0f11dbae0225d1f8a0c624bd04684f736137cc9dd6cc12ea34fbb378a"
    sha256 x86_64_linux:  "4f34e4c4e7ac9860dbf93bab04c722cef7a6d6b6983a647babe89b45e1faa9db"
  end

  conflicts_with "mono", because: "both install `csc`, `csi` binaries"

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
