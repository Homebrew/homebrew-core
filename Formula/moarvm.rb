class Moarvm < Formula
  desc "Virtual machine for NQP and Rakudo Perl 6"
  homepage "https://moarvm.org"
  # NOTE: Please keep these values in sync with nqp & rakudo when updating.
  url "https://github.com/MoarVM/MoarVM/releases/download/2021.09/MoarVM-2021.09.tar.gz"
  sha256 "9d233e62ac8e4d4580359a794f88f4d26edad54781d915f96b31464439a32cba"
  license "Artistic-2.0"
  revision 1

  livecheck do
    url "https://github.com/MoarVM/MoarVM.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_big_sur: "5cdfa62090556dabf3ff82ec1a4aa90fae77dd787f1f27eda6e69d52e8bb29f4"
    sha256 big_sur:       "f10c8d6e1815f918487b18fbb0b96dbe7fa729877207560f95f06202b42208da"
    sha256 catalina:      "2c0f4bd59164c854ea65abbdd63a98edc843141c321e93e85375fd3c6bb7da15"
    sha256 mojave:        "d9603dab3126485cd3af9ace65b09d83560a471996c2954249589ee5d901f729"
    sha256 x86_64_linux:  "ef617eb7eb82ec0ac50ce270e6cdd05b9d42a7806c5541000342e16ac3d15fed"
  end

  depends_on "libatomic_ops"
  depends_on "libffi"
  depends_on "libtommath"
  depends_on "libuv"

  conflicts_with "rakudo-star", because: "rakudo-star currently ships with moarvm included"

  resource "nqp" do
    url "https://github.com/Raku/nqp/releases/download/2021.09/nqp-2021.09.tar.gz"
    sha256 "7f296eecb3417e28a08372642247124ca2413b595f30e959a0c9938a625c82d8"
  end

  def install
    libffi = Formula["libffi"]
    ENV.prepend "CPPFLAGS", "-I#{libffi.opt_lib}/libffi-#{libffi.version}/include"
    configure_args = %W[
      --has-libatomic_ops
      --has-libffi
      --has-libtommath
      --has-libuv
      --optimize
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
