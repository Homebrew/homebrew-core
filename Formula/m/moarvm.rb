class Moarvm < Formula
  desc "VM with adaptive optimization and JIT compilation, built for Rakudo"
  homepage "https://moarvm.org"
  url "https://github.com/MoarVM/MoarVM/releases/download/2026.07/MoarVM-2026.07.tar.gz"
  sha256 "5a85c08a9eb0ff9686b799dc061cbb1a99384bcf2573b9822ca982643b6e613f"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "f8592faaa3d6880871d10ced47d942224aaaa922f02f97c54d66ee78c0916c5d"
    sha256 arm64_sequoia: "49960eb14ebcaa9f1b706ea79495a9dc1ebca3a377b9f1354a24210c5c53cc04"
    sha256 arm64_sonoma:  "1d807b3655086f6bf7582be60407166e9d8bf7035e67450907e80fc401ab5b80"
    sha256 sonoma:        "2e5a07d42990c5fdea2cfe08be08174b1b32a9cf7e18af273977a52f5f92dd71"
    sha256 arm64_linux:   "9ad9320914c60232f14f74ef36e7fba730ea12d758223c01dfa7bd6190c4b72b"
    sha256 x86_64_linux:  "b09ac1a6389f7705eb3e5227327cddb34766080b7479c91a4584a728184e6384"
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
    url "https://github.com/Raku/nqp/releases/download/2026.07/nqp-2026.07.tar.gz"
    sha256 "f1371190487873d55f0d1920dfed10d9623393c48b5b6ca34b96d6048ad22acc"

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
      --pkgconfig=#{formula_opt_bin("pkgconf")}/pkgconf
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
