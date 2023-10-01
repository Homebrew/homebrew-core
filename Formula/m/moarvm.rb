class Moarvm < Formula
  desc "VM with adaptive optimization and JIT compilation, built for Rakudo"
  homepage "https://moarvm.org"
  url "https://github.com/MoarVM/MoarVM/releases/download/2023.09/MoarVM-2023.09.tar.gz"
  sha256 "850db55daa771010629f11d4c3851d51eaac85d1b064fd68e8c0d5cedffb059f"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "f68ab31f049b69c96f2035d8dafd6ba47ad28a1ce297d85b6ff0a8fe385e0318"
    sha256 arm64_ventura:  "04f2cc489486610519c3e716eea580d6f24ab9d231c1c04e76a318850eae53a4"
    sha256 arm64_monterey: "3ab7583d13292e2a49531ce0bc0f43cdec19478590fe51374717a97affc04e03"
    sha256 arm64_big_sur:  "548ebe2602d96b6336103b5d5c7275744b27f80a3f1f467dfa62f7c01a13001c"
    sha256 sonoma:         "78754c7742e49a644dbb00c3c9383d3b9289359c9abd489ad427971f1c451635"
    sha256 ventura:        "db2e695b151cf359b8334547ef99794bde92d0cdadf388624a7b3a1f1dec0674"
    sha256 monterey:       "a8231753ece49dbf4f9efbe4b1c3e3aede96927162b23c545d885141681bdbb4"
    sha256 big_sur:        "f9ec52d75825e92140cb32dc0a911d3d5d2fe80f24d9b2fd63dabaa6f1a8282a"
    sha256 x86_64_linux:   "2a67be5464bbd532ef77d005d4996068e29cd7047147028b59620d519c49cebf"
  end

  depends_on "pkg-config" => :build
  depends_on "libtommath"
  depends_on "libuv"
  depends_on "zstd"

  uses_from_macos "perl" => :build
  uses_from_macos "libffi"

  conflicts_with "rakudo-star", because: "rakudo-star currently ships with moarvm included"

  resource "nqp" do
    url "https://github.com/Raku/nqp/releases/download/2023.09/nqp-2023.09.tar.gz"
    sha256 "45f36c0db1658dc0064e23d450cd6d9e8ff01528bc16a8d83e1472707066d968"
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
