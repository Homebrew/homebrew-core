class Moarvm < Formula
  desc "VM with adaptive optimization and JIT compilation, built for Rakudo"
  homepage "https://moarvm.org"
  url "https://github.com/MoarVM/MoarVM/releases/download/2026.04/MoarVM-2026.04.tar.gz"
  sha256 "65dc2242c9e71a52b85e636c1779408127910d51ecd462fb8c7376dc7a97917f"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "add60d3d33fb9022f81e445fa5df4cd3862c8b07cb37777982004ff44c8e3d17"
    sha256 arm64_sequoia: "c4db9b2d07c9fb88668f927a3840715e887f28388cccb3a65384c06fd9a154b4"
    sha256 arm64_sonoma:  "f0a5e624490ee79a4c63081176fde445942d67de93b57fb19cf93d97e31b70b3"
    sha256 sonoma:        "b95b8aa4310ed363301e33440bf06de288ef8669e3d791977af66450f7975c49"
    sha256 arm64_linux:   "6b8d20ec8649e421dbbe185bcdfe16262836fe09d838c1557b44c884cbef679b"
    sha256 x86_64_linux:  "15899910fe6c724cada442e259c519bd39a47d0db548ad9643c745fd7f96153f"
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
    url "https://github.com/Raku/nqp/releases/download/2026.04/nqp-2026.04.tar.gz"
    sha256 "f3ba05cb0b99848ff19994485dc6d57c47659a3a57637a169477eae6beb9737d"

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
