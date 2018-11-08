class Chicken < Formula
  desc "Compiler for the Scheme programming language"
  homepage "https://www.call-cc.org/"
  url "https://code.call-cc.org/releases/5.0.0/chicken-5.0.0.tar.gz"
  sha256 "a8b94bb94c5d6a4348cedd75dc334ac80924bcd9a7a7a3d6af5121e57ef66595"
  head "https://code.call-cc.org/git/chicken-core.git"

  bottle do
    sha256 "024d76a7ec8f9aeb46bf6add2395c3084f00c715c6a6dc6a99e80ffd1549c2a2" => :mojave
    sha256 "199bb0ca7a8b534fc1d5873d9bdd977bc7522f381fd35fea016a874a49fb1d19" => :high_sierra
    sha256 "b8e06f1d8f765466982ef62889aca28012ee21ebc613db9b3ed3490019999fcf" => :sierra
    sha256 "cb2786e345617675c288b2b3bc8a93300591fd19cfe4f9264d1d4ba17ae745d8" => :el_capitan
  end

  def install
    ENV.deparallelize

    args = %W[
      PLATFORM=macosx
      PREFIX=#{prefix}
      C_COMPILER=#{ENV.cc}
      LIBRARIAN=ar
      POSTINSTALL_PROGRAM=install_name_tool
    ]

    # Sometimes chicken detects a 32-bit environment by mistake, causing errors,
    # see https://github.com/Homebrew/homebrew/issues/45648
    args << "ARCH=x86-64" if MacOS.prefer_64_bit?

    system "make", *args
    system "make", "install", *args
  end

  test do
    assert_equal "25", shell_output("#{bin}/csi -e '(print (* 5 5))'").strip
  end
end
