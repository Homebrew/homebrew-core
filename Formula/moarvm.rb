class Moarvm < Formula
  desc "Virtual machine for NQP and Rakudo Perl 6"
  homepage "https://moarvm.org"
  # NOTE: Please keep these values in sync with nqp & rakudo when updating.
  url "https://github.com/MoarVM/MoarVM/releases/download/2021.07/MoarVM-2021.07.tar.gz"
  sha256 "8437ceefa5c132d0cf8328b22604e26f0a2a54c0377538aa9ae4bdfcf66d63fe"
  license "Artistic-2.0"

  livecheck do
    url "https://github.com/MoarVM/MoarVM.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_big_sur: "042d15c1dd99651addd6b6174062371976fd286f7bb5607cc93851d5aae77817"
    sha256 big_sur:       "a89e2efc2219b8d4a382b31cedb58996a75f8055cc53b2d9ee602152e57e92b0"
    sha256 catalina:      "e2e3d3ffaf9dc1b3df5432d90692f405b4b9c7464b4caca42da75ce5f85cb698"
    sha256 mojave:        "2db8f7e21c00dd56d7389806db9468d019f14dbad337d7194a8994276d71a984"
    sha256 x86_64_linux:  "b7316813d31849202726cd973b027f0f01cb422e41a6d29e8c012b5255872c81"
  end

  depends_on "libatomic_ops"
  depends_on "libffi"
  depends_on "libtommath"
  depends_on "libuv"

  conflicts_with "rakudo-star", because: "rakudo-star currently ships with moarvm included"

  resource "nqp" do
    url "https://github.com/Raku/nqp/releases/download/2021.07/nqp-2021.07.tar.gz"
    sha256 "dcaaf2a43ab3b752be6f4147a88abdc5b897e5ba85e536a0282bde8e4d363ea4"
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
