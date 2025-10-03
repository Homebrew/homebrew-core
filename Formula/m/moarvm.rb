class Moarvm < Formula
  desc "VM with adaptive optimization and JIT compilation, built for Rakudo"
  homepage "https://moarvm.org"
  url "https://github.com/MoarVM/MoarVM/releases/download/2025.08/MoarVM-2025.08.tar.gz"
  sha256 "2ad7f7de71c811420b2cbf2b859f6f54126e7862f7b2f663f6fdb00aa3e85629"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "38b0e614e3963a5a89d38189048f88d142402fc72bef77f080be4d51b985abac"
    sha256 arm64_sequoia: "b0beb150d75cd566492df2951da1c497fc232ebcb735d37c9918b89d10075e8e"
    sha256 arm64_sonoma:  "8198f61648f928b1b82350723f9a27a61f66a84397f2764de94ddbf903777e55"
    sha256 arm64_ventura: "df31ed5d357d4a3eed61dbb5e62ea81126ab158cdb794708602575bc15fbf064"
    sha256 sonoma:        "617fe95ccd8b1f25833691d14b2f8563f2f18c8b1586726253e83b252e855fd9"
    sha256 ventura:       "85d78544ba09a29a771091d68e3d546745c0fd5d3870a9665f4d406a32bff70c"
    sha256 arm64_linux:   "280ad0a7d7938ec73e6a80e22a54769907894990398d88dec76cb7197469a614"
    sha256 x86_64_linux:  "8c61acd78113676b5517ff9ceecdc28876fee33d36ad62f55cfd4ddebd512836"
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
    url "https://github.com/Raku/nqp/releases/download/2025.08/nqp-2025.08.tar.gz"
    sha256 "d7d6b42834fb81feeb6b6f0dc77174ebb50b827a3897e852fae68c0ae5614638"
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
