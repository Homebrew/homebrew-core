class Moarvm < Formula
  desc "VM with adaptive optimization and JIT compilation, built for Rakudo"
  homepage "https://moarvm.org"
  url "https://github.com/MoarVM/MoarVM/releases/download/2026.05/MoarVM-2026.05.tar.gz"
  sha256 "aa6d39debc9154fb353c94debb78690a52e61de0745f744d7f2f7144451e7295"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "eced0c08e9e831f66c2855d05ba0c86a1bbad1c01d60ffeaa0317f66298bf09b"
    sha256 arm64_sequoia: "324acabb152750ff63ef300dc0d639cd56cdc60199af44d8c53e073cc3951e34"
    sha256 arm64_sonoma:  "3d45b62ed6e050f5d6d5905e13780d304c99dca90c1469c6b4863678876c7bbb"
    sha256 sonoma:        "189c33140397dfe91e0bf8ae0c5be592a6156c33b5fee9cad3be6b0fd80dae7a"
    sha256 arm64_linux:   "2abb07760e92d6768db97fb592f2af2912d796f5d5caa728d0c26b94416a120d"
    sha256 x86_64_linux:  "06aaa205434061f92bce5db70d0647cd2132963a76bceb747bce7de0d67b6bbc"
  end

  depends_on "pkgconf" => :build
  depends_on "libtommath"
  depends_on "mimalloc"
  depends_on "zstd"

  uses_from_macos "perl" => :build
  uses_from_macos "libffi"

  on_macos do
    depends_on "libuv"
  end

  conflicts_with "moor", because: "both install `moar` binaries"
  conflicts_with "rakudo-star", because: "rakudo-star currently ships with moarvm included"

  resource "nqp" do
    url "https://github.com/Raku/nqp/releases/download/2026.05/nqp-2026.05.tar.gz"
    sha256 "f43085635bcda97c6e4163e827bcca34e46840f72316126246b94bc04ab58ebf"

    livecheck do
      formula :parent
    end
  end

  def install
    # Remove bundled libraries
    %w[dyncall libatomicops libtommath mimalloc].each { |dir| rm_r("3rdparty/#{dir}") }

    configure_args = %W[
      --c11-atomics
      --has-libffi
      --has-libtommath
      --has-mimalloc
      --optimize
      --pkgconfig=#{Formula["pkgconf"].opt_bin}/pkgconf
      --prefix=#{prefix}
    ]
    # FIXME: brew `libuv` causes runtime failures on Linux, e.g.
    # "Cannot find method 'made' on object of type NQPMu"
    if OS.mac?
      configure_args << "--has-libuv"
      rm_r("3rdparty/libuv")
    end

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
