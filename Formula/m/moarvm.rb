class Moarvm < Formula
  desc "VM with adaptive optimization and JIT compilation, built for Rakudo"
  homepage "https://moarvm.org"
  url "https://github.com/MoarVM/MoarVM/releases/download/2024.05/MoarVM-2024.05.tar.gz"
  sha256 "015c609132c1540c59291967a347c9bc8bd70944eaf1c586d938f4b27a8a7c66"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "fd0bd3b8f93b0664b10f7daa610dbdbd7ae48f12ce10656b44938bc68b346341"
    sha256 arm64_ventura:  "66206dc7f58f69de8266008f47b32fea24ca8aba3ce87e94c5d0bf04254ce119"
    sha256 arm64_monterey: "e08db046bff7d4bff76dbd38af9de91d97db47f57c96ca0e33718894f2f30e6b"
    sha256 sonoma:         "e2c8aae61ac8152089985e41b6f1d35c7b2fd8ef0fc78c7dd09574b73405a4c6"
    sha256 ventura:        "72e7035ca6bdc9454f3ed965995d9f2afad2b6c2fe5c1e5388dc815f3178ff7b"
    sha256 monterey:       "c90a088359083247b54b1c2bf33825e331903d97eca7cd449cf1fbfd1fd48638"
    sha256 x86_64_linux:   "79163ab29d622ed67d9d8ef9ca1ab7504c4d81aa8f0ea3e2552f3321b970ae0e"
  end

  depends_on "pkg-config" => :build
  depends_on "libtommath"
  depends_on "libuv"
  depends_on "zstd"

  uses_from_macos "perl" => :build
  uses_from_macos "libffi"

  conflicts_with "rakudo-star", because: "rakudo-star currently ships with moarvm included"

  resource "nqp" do
    url "https://github.com/Raku/nqp/releases/download/2024.05/nqp-2024.05.tar.gz"
    sha256 "74304a2781bb681ec0be97a45a9d4002e263ec00cc624f0350b217b6c0abbe82"
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
