class Moarvm < Formula
  desc "VM with adaptive optimization and JIT compilation, built for Rakudo"
  homepage "https://moarvm.org"
  url "https://github.com/MoarVM/MoarVM/releases/download/2023.05/MoarVM-2023.05.tar.gz"
  sha256 "c8e75883c1e1936d71ac081b21e8c2a344c80c6db5b4f8e1e6bb9481dd8b7547"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "d2a7df6c181ebbd498c68c47cb33c16c6b893f45585bc3869b596d0f14bbea6c"
    sha256 arm64_monterey: "865bca8d1701afb62aa345f4f4a252aa5bdb797af490df09999dfdafe9a1bcd6"
    sha256 arm64_big_sur:  "d5d3a0811b823b9d3fbbf8584435043f89f641ea90913071e4c35c51d91e80e1"
    sha256 ventura:        "975c9eccfcc79ea2531e70335e1f51ceead54b336d115af88fe5f786ad62622d"
    sha256 monterey:       "ee7d4e749226a89fdca79936e15ca4f5ed33cecb3da34b5444944ec272d824bf"
    sha256 big_sur:        "c46fafafb0ea2c12c73c6276f3a9f34c7273c4426a5722eba260ea0e3adcf0c1"
    sha256 x86_64_linux:   "ac0a91aac7cc22bf337e5f085d9563583fca809bb65d34b640c682cee43308b0"
  end

  depends_on "pkg-config" => :build
  depends_on "libtommath"
  depends_on "libuv"
  depends_on "zstd"

  uses_from_macos "perl" => :build
  uses_from_macos "libffi"

  conflicts_with "rakudo-star", because: "rakudo-star currently ships with moarvm included"

  resource "nqp" do
    url "https://github.com/Raku/nqp/releases/download/2023.05/nqp-2023.05.tar.gz"
    sha256 "1402db7e3ca6f2f3dfc1e98aa32e0e2a937e49b2a777a74c62268a98abb3bbd2"
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
