class Nqp < Formula
  desc "Lightweight Raku-like environment for virtual machines"
  homepage "https://github.com/Raku/nqp"
  url "https://github.com/Raku/nqp/releases/download/2024.02/nqp-2024.02.tar.gz"
  sha256 "a75c44099e69e1e623302be6f8edde3116d12aa370c6f502f0b9fc65ebf63fcf"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "ffa007b0093ca740e0fd6d1fc80e066e18534594a820d6cea7d056202ea7e889"
    sha256 arm64_ventura:  "6536fa0d0b7bd80c737d9ddada267dda8be9864260d594e33da0fc4ea77ce29d"
    sha256 arm64_monterey: "4c5df2c9132791230a46e5999b395cdd810822afd3c3ff2a103892de97d8bdd8"
    sha256 sonoma:         "54f246928a86ace3bc4f8c8561dc9b72bce5734e4b60d021cac444d5cb7a322a"
    sha256 ventura:        "6ada1e4ba73dcb0a7e85cdf05cd06fa530040d9eada04ac7906b8e89d0cf832b"
    sha256 monterey:       "c44356b2a1415364138c9f00a16da3c4fe66eca4b1a181512e7086b029ebc021"
    sha256 x86_64_linux:   "879ed1e795ae7607851c05173fbbc2f8d5de468ffaecf9058f47052ada7d7f4c"
  end

  depends_on "libtommath"
  depends_on "libuv"
  depends_on "moarvm"

  uses_from_macos "perl" => :build
  uses_from_macos "libffi"

  conflicts_with "rakudo-star", because: "rakudo-star currently ships with nqp included"

  def install
    ENV.deparallelize

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
