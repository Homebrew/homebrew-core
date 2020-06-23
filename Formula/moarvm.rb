class Moarvm < Formula
  desc "Virtual machine for NQP and Rakudo Perl 6"
  homepage "https://moarvm.org"
  url "https://github.com/MoarVM/MoarVM/releases/download/2020.06/MoarVM-2020.06.tar.gz"
  sha256 "db9759f16f76cb6d3b1f4baff9616c5ddb99fbb47ea62f54a5cc251b6ea99dc2"

  bottle do
    sha256 "6bd4dd19c0377aac0637cd4a992a3c8aa928d1e8fc346955a6f2d3a5c5ed2d69" => :catalina
    sha256 "fc9188a144ea9d40cf49e69eadd8f1d553f7d2b8205e35a929c81a9a3a13642c" => :mojave
    sha256 "f40f73e4db770efd9ded270775a8c4a50a5b064133abe77b7868f64662b7df91" => :high_sierra
  end

  depends_on "libatomic_ops"
  depends_on "libffi"
  depends_on "libtommath"
  depends_on "libuv"

  conflicts_with "rakudo-star", :because => "rakudo-star currently ships with moarvm included"

  resource("nqp") do
    url "https://github.com/perl6/nqp/releases/download/2020.05/nqp-2020.05.tar.gz"
    sha256 "291b92d9db968a691195adb1c9533edc1076d12d6617d6d931e40595e906b577"
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
