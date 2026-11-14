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
    sha256 arm64_golden_gate: "f91f2b5b4f2d1109fcfc48db09ab5a4113f9b45d5cd410a2912dbc32df0705cd"
    sha256 arm64_tahoe:       "7344dd2d74b76607c450fdc606e3bb626f3bc0ea430b497f0dabc52760dcdb29"
    sha256 arm64_sequoia:     "a91310fff6b712bf56bda6610227fdd20641244703d78bb79679e92edf493285"
    sha256 arm64_linux:       "37764e64773b41bee686cbde1a187ba10ea78ae90c1d0ca5ea4dc973fcc83250"
    sha256 x86_64_linux:      "50e35ccbc378b068de4abd5d0839613aad80b4f84e047fde3e3154da5610b876"
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
