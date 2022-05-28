class Moarvm < Formula
  desc "Virtual machine for NQP and Rakudo Perl 6"
  homepage "https://moarvm.org"
  url "https://github.com/MoarVM/MoarVM/releases/download/2022.04/MoarVM-2022.04.tar.gz"
  sha256 "ae06f50ba5562721a4e5eb6457e2fea2d07eda63e2abaa8c939c9daf70774804"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "9166013b6ab100c8fc2e40ce1e5758dfb841e02349602e1b64a16aafb6ab0b14"
    sha256 arm64_big_sur:  "24e491e822abc0ab158521eac5beb9c2a82dcff7971a060769e4ddd5ce79dbdb"
    sha256 monterey:       "a1d5c7d4e58d88422d167f46e056f7c10847aac78a993467ce03160779acbf8d"
    sha256 big_sur:        "3e08d7afe42ccc5606375d69bba68e2772e87736d2a38c4b019964afc4b69d81"
    sha256 catalina:       "10df00e4d29eabd6c97db11a5401203938e13d74bceadcbff00bd03b8fc373a0"
    sha256 x86_64_linux:   "1898ddea7dad0c2a1ebd80c486bdd41daa417bb0dd12561c743988a9832159b3"
  end

  depends_on "pkg-config" => :build
  depends_on "libffi"
  depends_on "libtommath"
  depends_on "libuv"

  uses_from_macos "perl" => :build

  conflicts_with "rakudo-star", because: "rakudo-star currently ships with moarvm included"

  resource "nqp" do
    url "https://github.com/Raku/nqp/releases/download/2022.04/nqp-2022.04.tar.gz"
    sha256 "556d458e25d3c0464af9f04ea3e92bbde10046066b329188a88663943bd4e79c"
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
