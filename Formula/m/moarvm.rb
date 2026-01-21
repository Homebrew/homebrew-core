class Moarvm < Formula
  desc "VM with adaptive optimization and JIT compilation, built for Rakudo"
  homepage "https://moarvm.org"
  url "https://github.com/MoarVM/MoarVM/releases/download/2025.12/MoarVM-2025.12.tar.gz"
  sha256 "23291b5fa7557c80d4ad3254d8e8bd51b3380989a1575b3d264dbe72a1cad1c0"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "b34284ac58b766be9d3fc80cd1106ba20d266690f3c9d3d898923597952eda62"
    sha256 arm64_sequoia: "50416aa38770ec17a0a16d38a546bb18f851915b456d1c4cc94c7c63f8bb19c3"
    sha256 arm64_sonoma:  "33a9ea6fa6a82111dfcd5b62ad7ae7fbdb8a33f6a5c89b6015bfac9bd94f50ad"
    sha256 sonoma:        "2a9b57585df431899b5d5db1908fafd9e33415080743eea2632716de256a1123"
    sha256 arm64_linux:   "1356f7a9422e54faa593d8c2cf44b9d11164545f4946a17aaa08789c7aa623ad"
    sha256 x86_64_linux:  "522149d7eecf9291af7d95c896f005a35de3922cb332234ecd2ccbdde450dae5"
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
    url "https://github.com/Raku/nqp/releases/download/2025.12/nqp-2025.12.tar.gz"
    sha256 "074147578bfc0d2f91a6702270517803ff4e960e9f175dfe14b00eee6febc0c6"

    livecheck do
      formula :parent
    end
  end

  # Fix build with a system provided libuv
  # PR Ref: https://github.com/MoarVM/MoarVM/pull/1981
  patch do
    url "https://github.com/MoarVM/MoarVM/commit/52a918c82bddeef58a842d112bcb42c6f33883ab.patch?full_index=1"
    sha256 "91b77fb7a11bfa9711e48745c3056ed5beb783234ac4728c7081a32b42349fba"
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
