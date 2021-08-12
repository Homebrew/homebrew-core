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
    sha256 arm64_big_sur: "6048e75a00ca5cd8d4de71d7ffa513b77310c688438258dc3ea7cedae5f2fdef"
    sha256 big_sur:       "b8a283f01a9cd95fc53fb655b2bae2ec83b1051613dc0ac1356926493588445d"
    sha256 catalina:      "aedc1f8bf1977088410fbf4e2eb15627b12ff75ff6f1bc9d813732cd2bb62021"
    sha256 mojave:        "ad7217c8112da4192a09f8846fdc41c62bdd7282dc0250393014c261c967920a"
    sha256 x86_64_linux:  "d9b1ca7642f6eae24643c7934881504d6e9a0438c1f4ea3b68647252f031d898"
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
