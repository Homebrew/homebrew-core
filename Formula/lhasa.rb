class Lhasa < Formula
  desc "LHA implementation to decompress .lzh and .lzs archives"
  homepage "https://fragglet.github.io/lhasa/"
  url "https://github.com/fragglet/lhasa/archive/v0.3.1.tar.gz"
  sha256 "ad76d763c7e91f47fde455a1baef4bfb0d1debba424039eabe0140fa8f115c5e"
  head "https://github.com/fragglet/lhasa.git"

  bottle do
    cellar :any
    sha256 "066d1b549b96700d8b7509e1f90b1564ddc66fc3b1dd18247b450c9990124f36" => :catalina
    sha256 "9b7b3503673097759714a75dc5ebc5a4c4e1184c88a80fa036bb39b2d896f0d8" => :mojave
    sha256 "36f6530ca2f2908bed047741ce52e41f4ec0d0d726bdd8ecb664958da821b527" => :high_sierra
    sha256 "d0abfc9315cfeff37781861e8c7ba2d3eb34003684560ee22a5dfb2acc4dfd5a" => :sierra
    sha256 "0d407f1058853c656a4aef717c1e72ff57472e0622fb344a5ef57c4c9ad8c3ee" => :el_capitan
    sha256 "afd0b2c24f4e4103c6ab8e918a972fda1b614890fc527bf314cc253e199013ee" => :yosemite
    sha256 "eecde92149160d0ec03d5b2f88408d67a4bc03b415ed4a78ff12474f6aa965f4" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  conflicts_with "lha", :because => "both install a `lha` binary"

  def install
    system "./autogen.sh", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    data = [
      %w[
        31002d6c68302d0400000004000000f59413532002836255050000865a060001666f6f0
        50050a4810700511400f5010000666f6f0a00
      ].join,
    ].pack("H*")

    pipe_output("#{bin}/lha x -", data)
    assert_equal "foo\n", (testpath/"foo").read
  end
end
