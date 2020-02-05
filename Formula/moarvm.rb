class Moarvm < Formula
  desc "Virtual machine for NQP and Rakudo Perl 6"
  homepage "https://moarvm.org"
  url "https://github.com/MoarVM/MoarVM/releases/download/2020.01.1/MoarVM-2020.01.1.tar.gz"
  sha256 "dcb61e44a098e8375c385eb9d52bd6394255a388697b2f6a52d88e6cf4a53587"

  bottle do
    sha256 "2f1c4e9b79eea7f66a0b1ca420e105d5c89d387b7b5240d70627018832e15139" => :mojave
    sha256 "063c019d2d2e193b472fb5b7ed749e7251be231840b781dea4f582d4be093047" => :high_sierra
    sha256 "470f77b3023f786c8e94742ce741c67b7473abe2b7fdd95a2b2ec244d3b31797" => :sierra
  end

  depends_on "libatomic_ops"
  depends_on "libffi"
  depends_on "libtommath"
  depends_on "libuv"

  resource("nqp") do
    url "https://github.com/perl6/nqp/releases/download/2020.01/nqp-2020.01.tar.gz"
    sha256 "4ccc9c194322c73f4c8ba681e277231479fcc2307642eeeb0f7caa149332965b"
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
