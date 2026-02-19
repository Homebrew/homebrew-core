class Moarvm < Formula
  desc "VM with adaptive optimization and JIT compilation, built for Rakudo"
  homepage "https://moarvm.org"
  url "https://github.com/MoarVM/MoarVM/releases/download/2026.01/MoarVM-2026.01.tar.gz"
  sha256 "0bb57343c864c2af55ab0d7fc7c99257e06bcf5399e0f8191a97127b7ff040de"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "046dafdb7d6c7c374b4ba9db321ec376ba3c247c6cdf06863a2e2ddbaa322d51"
    sha256 arm64_sequoia: "152d37b34d37eb40e734a4ecb68cd9386b4d5dc0437836000bf5713102afc81d"
    sha256 arm64_sonoma:  "25586ef430ad14b6f8314be3999e3080a9ff2c6c15ffba5a31dec9635d957c76"
    sha256 sonoma:        "1a50a0112d948ea14a36ef677fd2c73fc25a6144b99ece5f2f205bb427556a4c"
    sha256 arm64_linux:   "dccc21a1df5217495f33de49fd2942593f24430f996ec15f2f86e0be1681aeea"
    sha256 x86_64_linux:  "089e8da906371baa0f28085ccf37572f5f1e78fe5440de436525a5341930e501"
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
    url "https://github.com/Raku/nqp/releases/download/2026.01/nqp-2026.01.tar.gz"
    sha256 "6bb80256bc5274a2a89eac9b86fe8dd808b25657cf460ea0d3d847958ba54b25"

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
