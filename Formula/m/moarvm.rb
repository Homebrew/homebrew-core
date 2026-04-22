class Moarvm < Formula
  desc "VM with adaptive optimization and JIT compilation, built for Rakudo"
  homepage "https://moarvm.org"
  url "https://github.com/MoarVM/MoarVM/releases/download/2026.03/MoarVM-2026.03.tar.gz"
  sha256 "67fdab474d0041df7003235108a4c31bbb0e4b5c7c88bba204520e6488aefcb6"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "f3899928a2b821b2dad5f1daed17e3f51449a1def3f44aa3ee107c8140aefacb"
    sha256 arm64_sequoia: "4755af140ba43eb0486984a8a7c696e471d3e7131347780037e4581d97fdc924"
    sha256 arm64_sonoma:  "b9c5ae0521b7a981688df0c0671a61e7f3a42bd0c51ba0608c35b5f3567c9563"
    sha256 sonoma:        "3434d742fa3a5b27886196fef7f17d230cecc56be35c5fb63568fcfcf856b707"
    sha256 arm64_linux:   "6a9f0ac8e418ca7db456d4f42a7adf32eb90ef95608ee43af4a477256b7da340"
    sha256 x86_64_linux:  "f4a17c949516ddf38f6706d60e73db413c3da71441ac5f5a639d34cd051c7e85"
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
    url "https://github.com/Raku/nqp/releases/download/2026.03/nqp-2026.03.tar.gz"
    sha256 "e7c15fcb5a77a6b5295dba68a9bd3a2d3151a66851e1f82f7e8e701741c97da5"

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
