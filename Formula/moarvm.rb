class Moarvm < Formula
  desc "Virtual machine for NQP and Rakudo Perl 6"
  homepage "https://moarvm.org"
  # Note: Please keep these values in sync with nqp & rakudo when updating.
  url "https://github.com/MoarVM/MoarVM/releases/download/2020.10/MoarVM-2020.10.tar.gz"
  sha256 "637883083f16c4398ffd3685ea6411daa605dd0862e1f59cce632bb2b994f2c4"
  license "Artistic-2.0"

  livecheck do
    url "https://github.com/MoarVM/MoarVM.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 "9b3fee5144e62120ab86c10f0b66b648d9b6e2491c6ff5ea6c4c759c476bcb19" => :catalina
    sha256 "6887fbd716e7e9056cfc422ffbcd4632efb4292abfda92fc9353a7309d0a51d0" => :mojave
    sha256 "7cccf71f0ad76e2f8415c0c0a049c971c801bea1fd18bb0135819f1d0bce088f" => :high_sierra
  end

  depends_on "libatomic_ops"
  depends_on "libffi"
  depends_on "libtommath"
  depends_on "libuv"

  conflicts_with "rakudo-star", because: "rakudo-star currently ships with moarvm included"

  resource "nqp" do
    url "https://github.com/perl6/nqp/releases/download/2020.10/nqp-2020.10.tar.gz"
    sha256 "100c74c8a81117040c3a1b85ac99312008753c17faeeab7d69998bcf7cdb6059"
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
