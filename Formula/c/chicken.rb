class Chicken < Formula
  desc "Compiler for the Scheme programming language"
  homepage "https://www.call-cc.org/"
  url "https://code.call-cc.org/releases/5.4.0/chicken-5.4.0.tar.gz"
  sha256 "3c5d4aa61c1167bf6d9bf9eaf891da7630ba9f5f3c15bf09515a7039bfcdec5f"
  license "BSD-3-Clause"
  head "https://code.call-cc.org/git/chicken-core.git", branch: "master"

  livecheck do
    url "https://code.call-cc.org/releases/current/"
    regex(/href=.*?chicken[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:    "1385cbc267e0063638f30daade9a4b1ddd0561c99f50f6bc0eb4c429fd8344b6"
    sha256 arm64_sequoia:  "3154b68c1bdb7f409b86ecdba7f00d3b0042f616dfca65b72a53aeabd51e52b3"
    sha256 arm64_sonoma:   "937abf3f4f1b9c2c8fe12d091fe009e47be5c293db051314f37044c6ea18e58f"
    sha256 arm64_ventura:  "14359300f7a220a4b7756217f35ff22dd678c36bce8f24366d2f450cee37df81"
    sha256 arm64_monterey: "eeef1d3351f9ce6633fc224ad133b68af57ab1f57c224d756a877629018b3c0b"
    sha256 sonoma:         "4fb9fc2a51936c8219769352d50a5dc71a1a70437709a489e94125adb86c643c"
    sha256 ventura:        "c61f762a256633c5f9940a33d53c43204fe25e7e08283d30ed07f80b29753ea6"
    sha256 monterey:       "2772973cddc536ee5432553792f1bbc58812943ce2c51a0313db2dddaccae735"
    sha256 arm64_linux:    "1f5eb88a7eee5c47a26bd91ce9c9fd9c34a5dfcf8973f78e7294fb7897cfe07d"
    sha256 x86_64_linux:   "1091828584dfe4b0eaf42f4dac05b789f9933f2888cdccd56536363e3e107868"
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
