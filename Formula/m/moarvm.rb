class Moarvm < Formula
  desc "VM with adaptive optimization and JIT compilation, built for Rakudo"
  homepage "https://moarvm.org"
  url "https://github.com/MoarVM/MoarVM/releases/download/2024.01/MoarVM-2024.01.tar.gz"
  sha256 "b5b1f55af949b55e2e848014026a6afc2af474bceae254c63b6cd9983db87061"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "95e157f6ab46da119b9466883d467cc885bbcd8e25cbeb8a2d3a5642072716bf"
    sha256 arm64_ventura:  "9ccba56d92bb175d32ec07d3cfb63b2a83812b8b42a3de80beaf8ced236c790a"
    sha256 arm64_monterey: "aea8589f24d4d3031215e97790fb52c6cd1174fed350fcd8c7464a42cc90202e"
    sha256 sonoma:         "6beb1ed690561636a51e1c2b18577a501f1277a0685bd574021624c4b1a9455a"
    sha256 ventura:        "bf18828966eae24e7f5c38ba17d32eff5e3099dc3ecdb1fd1bdd94383a166a7b"
    sha256 monterey:       "6b9b9a7c5c1f9a01e3adea64e20432cfb767452048543e774c08fda957dcc352"
    sha256 x86_64_linux:   "2def8a3b2d74e913df2d28e2a92bbd156d4703b7294bb55e21fba9e1c0abdd39"
  end

  depends_on "pkg-config" => :build
  depends_on "libtommath"
  depends_on "libuv"
  depends_on "zstd"

  uses_from_macos "perl" => :build
  uses_from_macos "libffi"

  conflicts_with "rakudo-star", because: "rakudo-star currently ships with moarvm included"

  resource "nqp" do
    url "https://github.com/Raku/nqp/releases/download/2024.01/nqp-2024.01.tar.gz"
    sha256 "780cefef012dc457c1766e45397810f8261d7ff26c1e056da64a8893cd99f89e"
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
