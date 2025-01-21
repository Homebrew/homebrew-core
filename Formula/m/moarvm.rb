class Moarvm < Formula
  desc "VM with adaptive optimization and JIT compilation, built for Rakudo"
  homepage "https://moarvm.org"
  url "https://github.com/MoarVM/MoarVM/releases/download/2024.12/MoarVM-2024.12.tar.gz"
  sha256 "7f8ae605a19189ebb48a51bae486bacd32141326df8289509825bdb1bee3984c"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "76ce2ad41c6bd48baa4e6136ba4aba98e28d1cbbf5722f879878c1df1b60e259"
    sha256 arm64_sonoma:  "508e2ab97bcdc1ecbe2e0cc617321f8a40c6399f1e3a8ed0bba9f154b0db05f2"
    sha256 arm64_ventura: "ce4a40b33933e373dccd7ad8b26c6f216da5d3c9b860bb8c6e7a23f00907b072"
    sha256 sonoma:        "1a6b6206952be2c5054a74a5b90c76ff855bfe486fb2f90c3bb8a425d3c29870"
    sha256 ventura:       "56f13cc512c69691922fbbc66ffbb36de2307c2f23fb232f2fa074b58cb009d6"
    sha256 x86_64_linux:  "ce44335219f52ecd1d7bdd46de6f2603de1d43d44e2538c3cb78502879494e9c"
  end

  depends_on "pkgconf" => :build
  depends_on "libtommath"
  depends_on "libuv"
  depends_on "zstd"

  uses_from_macos "perl" => :build
  uses_from_macos "libffi"

  conflicts_with "moar", because: "both install `moar` binaries"
  conflicts_with "rakudo-star", because: "rakudo-star currently ships with moarvm included"

  resource "nqp" do
    url "https://github.com/Raku/nqp/releases/download/2024.12/nqp-2024.12.tar.gz"
    sha256 "026ff25d7eaae299b2d644e46b389642774cdf51fd803047f4291731dc4b2477"
  end

  def install
    configure_args = %W[
      --c11-atomics
      --has-libffi
      --has-libtommath
      --has-libuv
      --optimize
      --pkgconfig=#{Formula["pkgconf"].opt_bin}/pkgconf
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
