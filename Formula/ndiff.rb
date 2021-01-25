class Ndiff < Formula
  desc "Virtual package provided by nmap"
  homepage "https://www.math.utah.edu/~beebe/software/ndiff/"
  url "http://ftp.math.utah.edu/pub/misc/ndiff-2.00.tar.gz"
  sha256 "f2bbd9a2c8ada7f4161b5e76ac5ebf9a2862cab099933167fe604b88f000ec2c"
  license "GPL-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "409ac74964648efd98d55c7b07ffcb90066e23b08a50b495b4e43183fd3a9aef" => :big_sur
    sha256 "c7c14877b300c9a36d4047b883e773397f819f60718b9e13d17ca4359b317541" => :arm64_big_sur
    sha256 "0998b523aa16873d2ed4d776d29df511154e941ffba972d7560176c82add4515" => :catalina
    sha256 "1849064e29be787191a0e1dba0322ca1f06361cff18127a26a926e5e7c12c79c" => :mojave
    sha256 "e07f1749ab348c33f3918e0278ac4dacbb6aee0553dbb62434a8b59174d20746" => :high_sierra
    sha256 "ed6f753f9fe240486de3b6589350fcc0e7afbe345ae2e01bf6b47e132de9be4e" => :sierra
    sha256 "6faf20ce4c88110019c76cc4253cd65e5743fab7cff109fc8a7d41c8f411012e" => :el_capitan
    sha256 "80adff8ec563059b7f49005c7e567b950ca58b392a4a5db18ae4957fe18b296d" => :yosemite
    sha256 "7451587f9747af6e7ffd0e5dbacd337a72cd9b7f3c45a1240c2033e0731d5d46" => :mavericks
  end

  conflicts_with "nmap", because: "both install `ndiff` binaries"

  def install
    ENV.deparallelize
    # Install manually as the `install` make target is crufty
    system "./configure", "--prefix=.", "--mandir=."
    mkpath "bin"
    mkpath "man/man1"
    system "make", "install"
    bin.install "bin/ndiff"
    man1.install "man/man1/ndiff.1"
  end

  test do
    system "#{bin}/ndiff", "--help"
  end
end
