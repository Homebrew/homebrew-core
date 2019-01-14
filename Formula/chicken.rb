class Chicken < Formula
  desc "Compiler for the Scheme programming language"
  homepage "https://www.call-cc.org/"
  url "https://code.call-cc.org/releases/5.0.0/chicken-5.0.0.tar.gz"
  sha256 "a8b94bb94c5d6a4348cedd75dc334ac80924bcd9a7a7a3d6af5121e57ef66595"
  head "https://code.call-cc.org/git/chicken-core.git"

  bottle do
    sha256 "eee1a269507e626190797aa7768d581aca9cd83e21313f91ffde0139fd629009" => :mojave
    sha256 "aea05c909bd9f831daa2fcdc9c3f04a09aab0bb5634afd8162034504da6a5801" => :high_sierra
    sha256 "2083f2b685d91839bee340267d65713b3aa4024fed2b987fc3f51798910aef20" => :sierra
  end

  def install
    ENV.deparallelize

    args = %W[
      PLATFORM=macosx
      PREFIX=#{prefix}
      C_COMPILER=#{ENV.cc}
      LIBRARIAN=ar
      POSTINSTALL_PROGRAM=install_name_tool
      ARCH=x86-64
    ]

    system "make", *args
    system "make", "install", *args
  end

  test do
    assert_equal "25", shell_output("#{bin}/csi -e '(print (* 5 5))'").strip
  end
end
