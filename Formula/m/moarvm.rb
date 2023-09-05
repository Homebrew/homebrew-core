class Moarvm < Formula
  desc "VM with adaptive optimization and JIT compilation, built for Rakudo"
  homepage "https://moarvm.org"
  url "https://github.com/MoarVM/MoarVM/releases/download/2023.08/MoarVM-2023.08.tar.gz"
  sha256 "e711988a2312ab950aae85f617d45a5ef24109759af7635d21cf00dcff9909f9"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "c47ac4aa69a6d18ee6df3b0f762a4b7ee28babe92f4475920f2dd1d28e32d5c9"
    sha256 arm64_monterey: "7a2569d8f05765e37f10efd5a046c2c8b4d927cc503e03dd56ed0c0b6719c534"
    sha256 arm64_big_sur:  "a01d6933f141aabad04f103c219690aca91b6d6975b423997f158e6738ede9f4"
    sha256 ventura:        "f2b7f9198b27be2030dc5d3f14ebf526f246913e63e658243fe5f857d310b136"
    sha256 monterey:       "9dbee05dcc878b808d70fcfcfb27077cfa31fc5676d75d60555cf66800072071"
    sha256 big_sur:        "55ecdc4cda9a0848dcc0fe2b7daa24c53b47f9b2f17880db19e2ee6d4b7eb2df"
    sha256 x86_64_linux:   "31fcaf2c3cf8c6b1b2a7841fc39adf86d16e37096b686708ef3cbf066f651c67"
  end

  depends_on "pkg-config" => :build
  depends_on "libtommath"
  depends_on "libuv"
  depends_on "zstd"

  uses_from_macos "perl" => :build
  uses_from_macos "libffi"

  conflicts_with "rakudo-star", because: "rakudo-star currently ships with moarvm included"

  resource "nqp" do
    url "https://github.com/Raku/nqp/releases/download/2023.08/nqp-2023.08.tar.gz"
    sha256 "a0774ffa60b2d0f12f52ac433501ba4d5d4fafec8b3cf2baab8e0ac817455a25"
  end

  def install
    configure_args = %W[
      --c11-atomics
      --has-libffi
      --has-libtommath
      --has-libuv
      --optimize
      --pkgconfig=#{Formula["pkg-config"].opt_bin}/pkg-config
      --prefix=#{prefix}
    ]
    system "perl", "Configure.pl", *configure_args
    system "make", "realclean"
    system "make"
    system "make", "install"
  end

  test do
    testpath.install resource("nqp")
    out = Dir.chdir("src/vm/moar/stage0") do
      shell_output("#{bin}/moar nqp.moarvm -e 'for (0,1,2,3,4,5,6,7,8,9) { print($_) }'")
    end
    assert_equal "0123456789", out
  end
end
