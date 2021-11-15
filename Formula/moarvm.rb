class Moarvm < Formula
  desc "Virtual machine for NQP and Rakudo Perl 6"
  homepage "https://moarvm.org"
  url "https://github.com/MoarVM/MoarVM/releases/download/2021.10/MoarVM-2021.10.tar.gz"
  sha256 "7f3487a70e8b77be0e4e2f12b14c49f6a01d0378e0940c86958c9016c495ad75"
  license "Artistic-2.0"

  livecheck do
    url "https://github.com/MoarVM/MoarVM.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "436e41af0ca4dda10f631dc72880022b2c4a3f9a13e70396a0868faf95469f15"
    sha256 arm64_big_sur:  "597843c08e68f3cd5fc52784658f717ea5446502c87e2a3b2aa37c3f6d7aa633"
    sha256 monterey:       "dfcd06fdf3c2687a60b539ba4ba5c716be76c9914fb92d3294808e57cbd48b92"
    sha256 big_sur:        "872c02abcc6fe90d6f0b94548098256a39f89d0f9940e30046a09153ed5c3083"
    sha256 catalina:       "700c147ea3937944d141bb53360e34c35b5db5dae6610a4961f4f69c5c019cb1"
    sha256 x86_64_linux:   "37c836e7443315230c4255cd2c6993f3355a68d5022289e06d977b0a519e049f"
  end

  depends_on "libatomic_ops"
  depends_on "libffi"
  depends_on "libtommath"
  depends_on "libuv"

  conflicts_with "rakudo-star", because: "rakudo-star currently ships with moarvm included"

  resource "nqp" do
    url "https://github.com/Raku/nqp/releases/download/2021.10/nqp-2021.10.tar.gz"
    sha256 "48135bc1b3ce22c1c57ccef46531e7688eec83d6b905b502ffcefd6c23294b49"
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
