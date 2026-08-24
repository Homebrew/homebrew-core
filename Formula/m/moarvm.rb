class Moarvm < Formula
  desc "VM with adaptive optimization and JIT compilation, built for Rakudo"
  homepage "https://moarvm.org"
  url "https://github.com/MoarVM/MoarVM/releases/download/2026.08/MoarVM-2026.08.tar.gz"
  sha256 "805154e842baeb0a56194ed98c66a6fc94546a6dab8b3ffb982ebe97d7080a7a"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "de85977b03bedd6f270b16c6d7a997c73925a08368477677aefe4c023a21532d"
    sha256 arm64_sequoia: "04532be031e89a5050e2d949a4b0698aaab67f6c8f4e9e59916ae1db285cf9ef"
    sha256 arm64_sonoma:  "d2757433e0433227778b1017a133c5fe61b3f660c59f56bb278d5d78f3922582"
    sha256 sonoma:        "db0a5d9d558b57da40111544d4ee1634cfee7adf67e1c319346d6f72e6de1c21"
    sha256 arm64_linux:   "d0d2c476fee4926c17aa5dcea420ef1add5cd84909974da81714920deeaad322"
    sha256 x86_64_linux:  "87cbe488915b858ed796e1ccf43f2336766083f84e0651277d9748b681a7924d"
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
    url "https://github.com/Raku/nqp/releases/download/2026.08/nqp-2026.08.tar.gz"
    sha256 "120de1ac6f3246e7c5d04261ef18e64d9c3663f6670e952528d0d5c04b889cf2"

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
