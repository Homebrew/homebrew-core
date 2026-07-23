class Moarvm < Formula
  desc "VM with adaptive optimization and JIT compilation, built for Rakudo"
  homepage "https://moarvm.org"
  url "https://github.com/MoarVM/MoarVM/releases/download/2026.06/MoarVM-2026.06.tar.gz"
  sha256 "4d0735e1ca1f4a34869599370eec6fc12dae8bdf2d719a9cbbc940c9fc3b75d9"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "0af4a134c6ea471dcdf229d8f21c1653629dd0df8727f3c542da23b970f284d8"
    sha256 arm64_sequoia: "c03aefc328b20ec7778fcc959aacda45aa9544c0527f507d96b435d8189e9549"
    sha256 arm64_sonoma:  "2132ea8308d307e58116b865123397ed58bc6f96d06105f856f840278976784f"
    sha256 sonoma:        "24c21c69d940bdf4d618af94fa7c28947fbc740f27a87fed7b3c4bfd5abdafc1"
    sha256 arm64_linux:   "97ef34c04b8f39a05bd6e389acb0a18c3d972ef717b3c0a7315d1d2e1dad2e52"
    sha256 x86_64_linux:  "6ab1c0de242e76039f49f1b0366c72d4804196d28e9885a8688f43fff5a9f15f"
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
    url "https://github.com/Raku/nqp/releases/download/2026.06/nqp-2026.06.tar.gz"
    sha256 "51514df4be087d4bf767eb8eb594363a699962a5ad759a4a8a50d07b9b0af13e"

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
