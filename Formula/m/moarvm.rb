class Moarvm < Formula
  desc "VM with adaptive optimization and JIT compilation, built for Rakudo"
  homepage "https://moarvm.org"
  url "https://github.com/MoarVM/MoarVM/releases/download/2024.09/MoarVM-2024.09.tar.gz"
  sha256 "ea9b3b7ed126ce45619b8b5a4091ac2586603c9160130799a7d3e12795c14d24"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "a0b1a2c9714db7d2c0d76c3d2df65a13c31187a7383be3aa7a936253f9f58247"
    sha256 arm64_sonoma:  "d9cac2444f40b5875197dba7e46749c6ec80d9d5a54f90cd400a1ad91f901105"
    sha256 arm64_ventura: "cfd13314ef8d3cbcaf359e4b30582c57d40a540304ed8b03a3fc99de03d46251"
    sha256 sonoma:        "b7b8dc363c62cfc68f786f9157ee5270ad1b4cadd9be1191b4ce5cf217d41f7b"
    sha256 ventura:       "c90f145721c8235ce88cee88f3e3a94888ea2c7078612958c4bf2e46eadb3fa2"
    sha256 x86_64_linux:  "45430cc52404c0862038ccf969210ba2844cdafad607a5bad528f7704ea368e3"
  end

  depends_on "pkg-config" => :build
  depends_on "libtommath"
  depends_on "libuv"
  depends_on "zstd"

  uses_from_macos "perl" => :build
  uses_from_macos "libffi"

  conflicts_with "moar", because: "both install `moar` binaries"
  conflicts_with "rakudo-star", because: "rakudo-star currently ships with moarvm included"

  resource "nqp" do
    url "https://github.com/Raku/nqp/releases/download/2024.09/nqp-2024.09.tar.gz"
    sha256 "03de709b6353c4cc80aeb8ba2ef3fe54ec4bfe04ea6a10c631ca560b58cb181d"
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
