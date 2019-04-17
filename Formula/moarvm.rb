class Moarvm < Formula
  desc "Virtual machine for NQP and Rakudo Perl 6"
  homepage "https://moarvm.org"
  url "https://moarvm.org/releases/MoarVM-2019.03.tar.gz"
  sha256 "24b00e5228894fa6f70e9caa73114e5c6ec3686b6305e6e463807a93f70ffc04"

  bottle do
    sha256 "704a22721fb2a0d96d90903cdd4a6dd9c6da63ed1be33f466d26ffe5380d4024" => :mojave
    sha256 "c2f02994cca5fd03fc1a4a294dad62369c7169795cf197d780c4f8b0f2f683cc" => :high_sierra
    sha256 "516d7401ebabc18938e221c2e272b8a1435938f304846ed364c18d3c6464634c" => :sierra
  end

  depends_on "libatomic_ops"
  depends_on "libffi"
  depends_on "libtommath"
  depends_on "libuv"

  resource("nqp-2019.03") do
    url "https://rakudo.perl6.org/downloads/nqp/nqp-2019.03.tar.gz"
    sha256 "03ddced47583189a5ff316c05350f6f39c15f75ce44d38b409a4bb1128857fa0"
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
    testpath.install resource("nqp-2019.03")
    out = Dir.chdir("src/vm/moar/stage0") do
      shell_output("#{bin}/moar nqp.moarvm -e 'for (0,1,2,3,4,5,6,7,8,9) { print($_) }'")
    end
    assert_equal "0123456789", out
  end
end
