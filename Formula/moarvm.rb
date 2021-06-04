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
    sha256 arm64_big_sur: "356a704715539562fd2d3a20fdb56842cad046e2f6f303a438cf93eedaa2c46c"
    sha256 big_sur:       "48891aaba9d05bd6e1e453393d9b5e186470c84bc45108db3ca4490efddbfeb6"
    sha256 catalina:      "e1caba4345e6519e72ba4993788ae5ce427244a3891060b95da4d56a44edd453"
    sha256 mojave:        "06504b7a1cbc9bca35316bf73414edb745d2d474a034fdeb7df79d8d4104a59a"
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
