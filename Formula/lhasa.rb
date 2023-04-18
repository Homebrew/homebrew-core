class Lhasa < Formula
  desc "LHA implementation to decompress .lzh and .lzs archives"
  homepage "https://fragglet.github.io/lhasa/"
  url "https://github.com/fragglet/lhasa/archive/v0.3.1.tar.gz"
  sha256 "ad76d763c7e91f47fde455a1baef4bfb0d1debba424039eabe0140fa8f115c5e"
  license "ISC"
  head "https://github.com/fragglet/lhasa.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "081d94270fecc01d95be42d6c9a23e81ea8130c8d82f5b9496cd415eb94621ee"
    sha256 cellar: :any,                 arm64_monterey: "f2584155441658b209d336823dd3428b4da20896e6c478d34ef6870cef4b4c74"
    sha256 cellar: :any,                 arm64_big_sur:  "90f888591f8bbbbc49b3616dfc43287474a510517cc1222488ac8a707f9968b8"
    sha256 cellar: :any,                 ventura:        "1e6e2c4243ead9c658f121e0f2a8e8212bdd2a0a3310cb7615c550c49eac22ca"
    sha256 cellar: :any,                 monterey:       "ebf620d9a216397aad8a1f0a67cb70e22fd4ae011ebad98fdd7c91477ee3b4cf"
    sha256 cellar: :any,                 big_sur:        "7e1f12414e857455d57b3f943d50d921a189e817e264b14a9a0467e661e8cfc2"
    sha256 cellar: :any,                 catalina:       "066d1b549b96700d8b7509e1f90b1564ddc66fc3b1dd18247b450c9990124f36"
    sha256 cellar: :any,                 mojave:         "9b7b3503673097759714a75dc5ebc5a4c4e1184c88a80fa036bb39b2d896f0d8"
    sha256 cellar: :any,                 high_sierra:    "36f6530ca2f2908bed047741ce52e41f4ec0d0d726bdd8ecb664958da821b527"
    sha256 cellar: :any,                 sierra:         "d0abfc9315cfeff37781861e8c7ba2d3eb34003684560ee22a5dfb2acc4dfd5a"
    sha256 cellar: :any,                 el_capitan:     "0d407f1058853c656a4aef717c1e72ff57472e0622fb344a5ef57c4c9ad8c3ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ea5cc36df44bf7e1b604f93003609cc3386172cad0875f3516435505c574839"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  conflicts_with "lha", because: "both install a `lha` binary"

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
