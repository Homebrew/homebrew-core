class Moarvm < Formula
  desc "Virtual machine for NQP and Rakudo Perl 6"
  homepage "https://moarvm.org"
  # NOTE: Please keep these values in sync with nqp & rakudo when updating.
  url "https://github.com/MoarVM/MoarVM/releases/download/2021.08/MoarVM-2021.08.tar.gz"
  sha256 "b4cddab6f4aea04bcb4348b8412f5ded813e339a7d38bb9aefde2987f19a1cf7"
  license "Artistic-2.0"

  livecheck do
    url "https://github.com/MoarVM/MoarVM.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_big_sur: "0d633d6562d73f244de187266b43c8382d2a5aa77f7a4ae0f873ca2553c0ece4"
    sha256 big_sur:       "7ee896d3b29e042afcae6e043e5e67ac8acdc11a8ed498217390eebee23ae555"
    sha256 catalina:      "54da0a4d0e2d01bffa3ed5f1bc889bc344c1505ac76bb1c6f43c2b9c4d6e574c"
    sha256 mojave:        "95db77fd8765984698ebddc2ed39b320a5e589430ff51e93150bcc2b132840cd"
    sha256 x86_64_linux:  "61d41720a1b1eb130db49b11bbc19c9697df88f638261f82fafcab5f5a566a2f"
  end

  depends_on "libatomic_ops"
  depends_on "libffi"
  depends_on "libtommath"
  depends_on "libuv"

  conflicts_with "rakudo-star", because: "rakudo-star currently ships with moarvm included"

  resource "nqp" do
    url "https://github.com/Raku/nqp/releases/download/2021.08/nqp-2021.08.tar.gz"
    sha256 "bb01cf11cbba910047259b75c8bfba83b557acaab170f64f24810fbd5f69319b"
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
