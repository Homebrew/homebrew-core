class Moarvm < Formula
  desc "Virtual machine for NQP and Rakudo Perl 6"
  homepage "https://moarvm.org"
  url "https://moarvm.org/releases/MoarVM-2018.12.tar.gz"
  sha256 "e433a2a56953fca16ed8eaf9a597f25a7e1556436888609429f38529c241693b"

  bottle do
    sha256 "f4a1e65148f4f0f32713a3090b9c12db01133844bac50dd42641183561242cb9" => :mojave
    sha256 "fe1d3d362c2b503601b6ef697c869fe2e19846ae454948ca05ea69155c866c27" => :high_sierra
    sha256 "ed173e56ec8c4fd58708a0618ef9efcf074e467ca2934185cf16b03065ee068e" => :sierra
  end

  depends_on "libatomic_ops"
  depends_on "libffi"
  depends_on "libtommath"
  depends_on "libuv"

  resource("nqp-2018.12") do
    url "https://rakudo.perl6.org/downloads/nqp/nqp-2018.12.tar.gz"
    sha256 "219db519ad5c1848e4528a56a506dd74b0839ca1d910788411f3bfedf5045d36"
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
    testpath.install resource("nqp-2018.12")
    out = Dir.chdir("src/vm/moar/stage0") do
      shell_output("#{bin}/moar nqp.moarvm -e 'for (0,1,2,3,4,5,6,7,8,9) { print($_) }'")
    end
    assert_equal "0123456789", out
  end
end
