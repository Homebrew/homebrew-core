class Nqp < Formula
  desc "Lightweight Raku-like environment for virtual machines"
  homepage "https://github.com/Raku/nqp"
  url "https://github.com/Raku/nqp/releases/download/2023.02/nqp-2023.02.tar.gz"
  sha256 "e35ed5ed94ec32a6d730ee815bf85c5fcf88a867fac6566368c1ad49fe63b53f"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "59a2dbb756dbf73cb7ff0fe413f314e4f6599410b229f6fcf3a96827bf0c2cbd"
    sha256 arm64_monterey: "0e406a5568285153e5379518373a9836d6f1c3c248e964508dc30101c9d350e6"
    sha256 arm64_big_sur:  "b52b07e6a97e32e2039f6b1271d89fe8c9ed066706cde5fbe5e91039bc58afba"
    sha256 ventura:        "adff5d56dd37090635005143040a4c39fddb146dc941ea169377cd07408d84fe"
    sha256 monterey:       "e6b6e5c08798c239424aa59c8e35e22c580d357c5283d230d744c21915f08585"
    sha256 big_sur:        "8aa626afecc645a85507d76db3f3ee640e5449f3cf8e3295cb07494008309b14"
    sha256 x86_64_linux:   "4446b1aa209026c2368abc6e0189a33380486158953488555f6891df46e2ec24"
  end

  depends_on "libtommath"
  depends_on "libuv"
  depends_on "moarvm"

  uses_from_macos "perl" => :build
  uses_from_macos "libffi"

  conflicts_with "rakudo-star", because: "rakudo-star currently ships with nqp included"

  def install
    # Work around Homebrew's directory structure and help find moarvm libraries
    inreplace "tools/build/gen-version.pl", "$libdir, 'MAST'", "'#{Formula["moarvm"].opt_share}/nqp/lib/MAST'"

    system "perl", "Configure.pl",
                   "--backends=moar",
                   "--prefix=#{prefix}",
                   "--with-moar=#{Formula["moarvm"].bin}/moar"
    system "make"
    system "make", "install"
  end

  test do
    out = shell_output("#{bin}/nqp -e 'for (0,1,2,3,4,5,6,7,8,9) { print($_) }'")
    assert_equal "0123456789", out
  end
end
