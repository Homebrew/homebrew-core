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
    sha256 arm64_big_sur: "c5f2d2d7bacda98e06029b38d5826b4efaebe5729f2d70dc282bd13c787692d3"
    sha256 big_sur:       "73e1c8c6913dbd4517220b0be439ad11fdb416db6bb8ec361b36b857b645f38b"
    sha256 catalina:      "7dd7acdb735036d925082e907816000d4765f1549c20208ab7cba7395601dcbf"
    sha256 mojave:        "7f1875146667613ec2095e804ea74112c6d7a764e9136b945a30521823348b66"
    sha256 x86_64_linux:  "91705c45d1e7b2b2ee02ac1db3e1a147c5ac4fc31df168928b4cade93f53e36e"
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
