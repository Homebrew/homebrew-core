class Moarvm < Formula
  desc "VM with adaptive optimization and JIT compilation, built for Rakudo"
  homepage "https://moarvm.org"
  url "https://github.com/MoarVM/MoarVM/releases/download/2026.11/MoarVM-2026.11.tar.gz"
  sha256 "75d3ebf889351294fab7222ad4eb966c74cefbef4cbe0073e397083394a663d4"
  license "Artistic-2.0"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "67b458811eafd8b591b4e453485db99ebda781210c68f9280e8d9ed050df749d"
    sha256 arm64_tahoe:       "7c745a7aa6c4e637ae74ed2f9a920ad83047f0049b4727801a8969605095689c"
    sha256 arm64_sequoia:     "8828a9bbea189206c61fc38c5afeca18489df9aaf76efaf1e53545eb227c66d8"
    sha256 arm64_linux:       "59692298507854d661a9d0f73a6ff61bf54f781358c14e86bececf6fc647a0c0"
    sha256 x86_64_linux:      "09e48ca379307ee147ac5ee33c07a53751c9df03ed5a5fc403b7a88b1f99be9c"
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

  resource "nqp", :test do
    url "https://github.com/Raku/nqp/releases/download/2026.11/nqp-2026.11.tar.gz"
    sha256 "a40d60b0062925e6e09d4fed219dafb2b9d23df22052a445a61790aa0bdbaad5"

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
