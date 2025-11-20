class Moarvm < Formula
  desc "VM with adaptive optimization and JIT compilation, built for Rakudo"
  homepage "https://moarvm.org"
  url "https://github.com/MoarVM/MoarVM/releases/download/2025.11/MoarVM-2025.11.tar.gz"
  sha256 "dce1e7aa90cf5d4cef0fdb90a096d69954021bcdef1d3cc67b2109bb66d54f5b"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "b39374434de4052333abfefcbbf1c44516309a30314b78871a7fce235fd360a7"
    sha256 arm64_sequoia: "6e5b6608249aa91da6ea126cb36e33d8655692d2fccef9d36b2d9e449deb2f8c"
    sha256 arm64_sonoma:  "e9256cf4f8cd716d02f9c98024ac368fe0e9400fbff9270688f524338b68d8ba"
    sha256 sonoma:        "cbdc144b5fbe6258cf5621cde50ebe6f65a5b2d9671a3d437543442e7cf43f28"
    sha256 arm64_linux:   "35fa802ddc6c5d096314e1513b5359878af7422c9e976af7009bc58a9be88f7e"
    sha256 x86_64_linux:  "3e6cc8abb810c757841d0a78683f4c1330a90204d84aaad64e4703a0a2276d2e"
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
    url "https://github.com/Raku/nqp/releases/download/2025.11/nqp-2025.11.tar.gz"
    sha256 "bcd772c39d6446d771260897c5450c559f9ef07539d1c4e622035549e85e832a"

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
