class Moarvm < Formula
  desc "VM with adaptive optimization and JIT compilation, built for Rakudo"
  homepage "https://moarvm.org"
  url "https://github.com/MoarVM/MoarVM/releases/download/2025.02/MoarVM-2025.02.tar.gz"
  sha256 "32a754c6daa5587084318614a8914b3df3c6cb434fc9469f38f1449d4bfa0974"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "c94ab4080698ac900c861a454f3bd18d5107d9941a5ee1ba65fa29ea7643c3c5"
    sha256 arm64_sonoma:  "d0daf2e1e31e981b7f56b165ce6aac15b498fc46998a515482b7d52ddfbcb51e"
    sha256 arm64_ventura: "8d65d32f6c675c01a9c97892805082ded09c31c15e11f9a9b6fa9705b2a9f7d6"
    sha256 sonoma:        "8fbc004da24cdd88c427864683f28f553539147bbe95f51de867137861d59b67"
    sha256 ventura:       "c2b55ea0d08d8650d7afec05e38acb09c31b769c348a29e9838870e6f4711362"
    sha256 x86_64_linux:  "9a8f30a352a1a1b472c9caa611f9b7a262fc3f4c1c5d307fe7a738d37d1c25d6"
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

  conflicts_with "moar", because: "both install `moar` binaries"
  conflicts_with "rakudo-star", because: "rakudo-star currently ships with moarvm included"

  resource "nqp" do
    url "https://github.com/Raku/nqp/releases/download/2025.02/nqp-2025.02.tar.gz"
    sha256 "6cc4321cebecbe656e92b5ca0d245d50a5ecbda74ea28ca08c010c21a7d47dad"
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
