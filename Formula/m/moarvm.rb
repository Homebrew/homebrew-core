class Moarvm < Formula
  desc "VM with adaptive optimization and JIT compilation, built for Rakudo"
  homepage "https://moarvm.org"
  url "https://github.com/MoarVM/MoarVM/releases/download/2024.04/MoarVM-2024.04.tar.gz"
  sha256 "499f2aa1d8b85db5b4335a1b5ae72b0bf8d80534c9a3b663f2c3a04a75c975ee"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "424a5a1348c0aa0ba5801b298de6e0ff961e342a15b1645d040cd127e5eb766d"
    sha256 arm64_ventura:  "fe6c6f9a667a0284c097de27a3bdf07ac225db15ecd62d709b98894331fa7e28"
    sha256 arm64_monterey: "476da405da738ee99784cc640b1eee7a32039ee61784270b55ab25f63c555252"
    sha256 sonoma:         "2ff43e998967e0dda8df7290c7653945653deb571cf7157b67d110a08b5479d6"
    sha256 ventura:        "d7bab955f4cad5f6e32ef9ae8aca5a08f3ed39b316bcc6fc70ecccbce8dadaba"
    sha256 monterey:       "a959ea5cf6a678869d9e9637cc186f0d11775c15cd2ce574256aa81b2f6185f9"
    sha256 x86_64_linux:   "c112af2a4329f26dc3bd6b24e4a1770de18d8edad186df408542ac7ff2d37010"
  end

  depends_on "pkg-config" => :build
  depends_on "libtommath"
  depends_on "libuv"
  depends_on "zstd"

  uses_from_macos "perl" => :build
  uses_from_macos "libffi"

  conflicts_with "rakudo-star", because: "rakudo-star currently ships with moarvm included"

  resource "nqp" do
    url "https://github.com/Raku/nqp/releases/download/2024.04/nqp-2024.04.tar.gz"
    sha256 "cea588b0c7c0c03095541989383fef509b78f5ad4ab0657a32baeab6579b8ae9"
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
