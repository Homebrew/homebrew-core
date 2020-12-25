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
    sha256 "594d181a78097b848f2a488eb25f3a9274b12f54bdc546cc165c741e617df0ba" => :big_sur
    sha256 "e8f236a150aa07d48f4d2a5eaabd175e38acb52c7a5e1704a1a6c1c193b20d94" => :arm64_big_sur
    sha256 "f012d9ed40ea2ee121057fbf07799a5bec307d0af7524c2d973d30a32c8fcced" => :catalina
    sha256 "c478335cb67dd1c5388c20abebafb7174a3280687dd6cb4c2b9d022f7c9b1736" => :mojave
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
