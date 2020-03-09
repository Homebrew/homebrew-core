class Moarvm < Formula
  desc "Virtual machine for NQP and Rakudo Perl 6"
  homepage "https://moarvm.org"
  url "https://github.com/MoarVM/MoarVM/releases/download/2020.02.1/MoarVM-2020.02.1.tar.gz"
  sha256 "82cb80b29ad7aebb0c0b42449d371eafa8935b07884526345f9788c8bcf4d632"
  revision 1

  bottle do
    sha256 "b56296c0681c26250f45e32a2a5bedbc63ca8a490b85d70636353868928a9399" => :catalina
    sha256 "7ec0cad31f6766eaa4eed3d8392cc73208cd77772ba0cc24fa85501a630d075f" => :mojave
    sha256 "fff9bc929390889d239bdb32f47adaaf9b5c006d83fc150fc6056e4ea5929d0c" => :high_sierra
  end

  depends_on "libatomic_ops"
  depends_on "libffi"
  depends_on "libtommath"
  depends_on "libuv"

  conflicts_with "rakudo-star", :because => "rakudo-star currently ships with moarvm included"

  resource("nqp") do
    url "https://github.com/perl6/nqp/releases/download/2020.02.1/nqp-2020.02.1.tar.gz"
    sha256 "f2b5757231b006cfb440d511ccdcfc999bffabe05c51e0392696601ff779837f"
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
