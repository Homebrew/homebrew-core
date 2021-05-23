class Moarvm < Formula
  desc "Virtual machine for NQP and Rakudo Perl 6"
  homepage "https://moarvm.org"
  # NOTE: Please keep these values in sync with nqp & rakudo when updating.
  url "https://github.com/MoarVM/MoarVM/releases/download/2021.05/MoarVM-2021.05.tar.gz"
  sha256 "b14c8778664e3bcaed9cfde3c7b3a3b1898be5f839efee7464979e3954a6a897"
  license "Artistic-2.0"

  livecheck do
    url "https://github.com/MoarVM/MoarVM.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_big_sur: "c5dc401d754d5a3c4e5af6e7c13a9f64394b67ce175e2ea7e0d8b47624293020"
    sha256 big_sur:       "5dea1d48117b7378202b64b01f6db2291244d1819d7b795314a5fd60a030a8fc"
    sha256 catalina:      "3d7ebc9b0421522e3665782bdec5d1623262ce93d5b85beca5592b1c0ee0a01a"
    sha256 mojave:        "916f9dd2bf9e063f40832e7b96faddcb95c423dede814077b7be493184e3fdb2"
  end

  depends_on "libatomic_ops"
  depends_on "libffi"
  depends_on "libtommath"
  depends_on "libuv"

  conflicts_with "rakudo-star", because: "rakudo-star currently ships with moarvm included"

  resource "nqp" do
    url "https://github.com/Raku/nqp/releases/download/2021.05/nqp-2021.05.tar.gz"
    sha256 "b43cf9d25a8b3187c7e132e1edda647d58bc353ca0fb534cc9aa0f8df7fff73f"
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
