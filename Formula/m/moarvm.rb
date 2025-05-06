class Moarvm < Formula
  desc "VM with adaptive optimization and JIT compilation, built for Rakudo"
  homepage "https://moarvm.org"
  url "https://github.com/MoarVM/MoarVM/releases/download/2025.04/MoarVM-2025.04.tar.gz"
  sha256 "71c44dce2d3d6630959a3ffd95e5bb456433426635217f1a77efde152c11109c"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "528a377c060a38b277a09de993360f48e289713873cc797d21ab3dfc16952202"
    sha256 arm64_sonoma:  "4ee294808e8515772563e482acb0b7cc26686398720456df7ccdb461e97b4e88"
    sha256 arm64_ventura: "b7c902d177369c62a349c827d3aec1d9cf1f63b8175a09868996c9cff55a79aa"
    sha256 sonoma:        "0466fa55712c186964dccac1f4bc2774b43c2441cbf80ca82c25193348fcfc1b"
    sha256 ventura:       "2b582555de1d278dd80f4ec926090ad10ff99edabb104267e09080da211ef1b3"
    sha256 arm64_linux:   "fc077769e4a3675e673067e2fe0da748941e129eea8832a8c9e523fff7f21fa0"
    sha256 x86_64_linux:  "e1e8c2652328a0116c78a5ee4c6a5104217a8ae0b366ba413b106fcac7b7e5bc"
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
    url "https://github.com/Raku/nqp/releases/download/2025.04/nqp-2025.04.tar.gz"
    sha256 "6468566fd63a75b743979df433beab99690125c4d90972c3b371f6ace82528a0"
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
