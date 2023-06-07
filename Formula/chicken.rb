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
    sha256 arm64_ventura:  "725c379c3149258014d47f3020e0fe1f884f3597d5e7ebd95fe60ac384b94873"
    sha256 arm64_monterey: "735eaf1eff7d654129834cf32300deaa9967a154a05e8d646715061a817dbccd"
    sha256 arm64_big_sur:  "41364c265c005a36f35b92e71e5442b478a31350ec2c3fdc56014a89b01b49ed"
    sha256 ventura:        "81b173fbdafe7ab814bf91126d30afb1385aead51485cd0e7c9d6185b47edb78"
    sha256 monterey:       "5f24e343e712def1c09cff350d1ee69abd79a23699d64d766e36072933390699"
    sha256 big_sur:        "d7e2e910b7744978bf4cc87f09088d5460c40918a2b2368f2e57646b4c8ddb48"
    sha256 catalina:       "b05075013a96eb98358be15f57417b4bf511ed8d93a78b1a330dcb4be1a14046"
    sha256 x86_64_linux:   "e2b200753be38c69074918464c322b94d0468d234b332b69d77ed074a372cbd9"
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
