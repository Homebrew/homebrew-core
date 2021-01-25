class Moarvm < Formula
  desc "Virtual machine for NQP and Rakudo Perl 6"
  homepage "https://moarvm.org"
  # NOTE: Please keep these values in sync with nqp & rakudo when updating.
  url "https://github.com/MoarVM/MoarVM/releases/download/2020.12/MoarVM-2020.12.tar.gz"
  sha256 "08914f1c464151ebc678cf0d360c9e479a036178fa7c9ddfd34aa4d556d03ea2"
  license "Artistic-2.0"

  livecheck do
    url "https://github.com/MoarVM/MoarVM.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 "b585777c5b31b6d7865fcb389bc694ad86b48e1dc15b29e34bec61183f17004c" => :big_sur
    sha256 "cce99fb71c2e3605bd3a05df6ca700b63d41c95ea410ac32d72dc726d94683e4" => :arm64_big_sur
    sha256 "a93ea32a0ccf20cf05300ff1c06edc93de3679b3c70503e84a627c3ffdaba14e" => :catalina
    sha256 "e3f3ed409f05c8d38046a3a0c18c35d2d1e89fdb8369420814f7de91ca6f3997" => :mojave
  end

  depends_on "libatomic_ops"
  depends_on "libffi"
  depends_on "libtommath"
  depends_on "libuv"

  conflicts_with "rakudo-star", because: "rakudo-star currently ships with moarvm included"

  resource "nqp" do
    url "https://github.com/perl6/nqp/releases/download/2020.12/nqp-2020.12.tar.gz"
    sha256 "fd445b3c3b844a2fc523dc567b2a65c4dc2cc9a3f42ef2e860ef71174823068e"
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
