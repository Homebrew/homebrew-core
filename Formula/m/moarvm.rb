class Moarvm < Formula
  desc "VM with adaptive optimization and JIT compilation, built for Rakudo"
  homepage "https://moarvm.org"
  url "https://github.com/MoarVM/MoarVM/releases/download/2025.05/MoarVM-2025.05.tar.gz"
  sha256 "61fc9ecc8b479ccc8d389fc73cce927c9f5b1070a9c62c60a0817f89dc832d91"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "34de90dc55d45a885b4266758435ee5a07c2a08c1d060d3d906263562db0e48d"
    sha256 arm64_sonoma:  "ed2b051247569eb1146ac68b323b82ae94e5ab437716fdd469f0b035813daa89"
    sha256 arm64_ventura: "f41d4b67329a915df09209cd70524ec43034305337516a85c1237cf8aa14a497"
    sha256 sonoma:        "aa3ad74ef5ff21cbbefa69c311e108ee5e90eeeac16c689f92287313d55174f9"
    sha256 ventura:       "9f15c1612eceb488c7dd36b1ee59493865f59e7e16f6cc13c9dcf90fa90b8e65"
    sha256 arm64_linux:   "e557552f00cd918410acdfbd1e46ff0eb5efa547f9dd8049b81639090ff698f7"
    sha256 x86_64_linux:  "665239877afbccff09f81aa945695eca2be3bbdaa1e2eed7bebb218581414ca1"
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
    url "https://github.com/Raku/nqp/releases/download/2025.05/nqp-2025.05.tar.gz"
    sha256 "51f72f3c3cdd8e87fabd1601eab7c6dfef201dd4b65946848a6e38370e99458f"
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
