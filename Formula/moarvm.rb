class Moarvm < Formula
  desc "VM with adaptive optimization and JIT compilation, built for Rakudo"
  homepage "https://moarvm.org"
  url "https://github.com/MoarVM/MoarVM/releases/download/2023.06/MoarVM-2023.06.tar.gz"
  sha256 "143f92510eaa3452c712e4aae9f44d84cd078f16517b40252bab7dd5e224ecdb"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "a014a860226cc28444561ac2fd0c054b526693a71a9d2e33b9b0c9588aa1e170"
    sha256 arm64_monterey: "135d7bbd36b96bc859c24edcc520171262d39c66fdb863f4493a8d18cacdba15"
    sha256 arm64_big_sur:  "25cde0a02f50b2c029a35dac8094ad2573ba27b16ccdafab558dd809cd82c7ad"
    sha256 ventura:        "15c04dc422316bf00657ccad8fbbdcbb377040f42039aaa9f0eeb0bdb36ce1a2"
    sha256 monterey:       "2dcf9154f9b3b7adbcbf4ed5d42a894bbda6252317b7eaedc11c9834ace95002"
    sha256 big_sur:        "40e97defe5f76329051f4c3f1b54fc617e3122392c7fdfc94c786a64e4bc7257"
    sha256 x86_64_linux:   "7f6104ec8df30d0c9888d632fe4cd9117e5b8dd62e4f2596b7e84084c55d0150"
  end

  depends_on "pkg-config" => :build
  depends_on "libtommath"
  depends_on "libuv"
  depends_on "zstd"

  uses_from_macos "perl" => :build
  uses_from_macos "libffi"

  conflicts_with "rakudo-star", because: "rakudo-star currently ships with moarvm included"

  resource "nqp" do
    url "https://github.com/Raku/nqp/releases/download/2023.06/nqp-2023.06.tar.gz"
    sha256 "ddcb92f29180699ebaf0a7faa46ad4ac902f9c8826d7476d9c6f71176cadd7d3"
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
