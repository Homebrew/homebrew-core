class Nqp < Formula
  desc "Lightweight Raku-like environment for virtual machines"
  homepage "https://github.com/Raku/nqp"
  url "https://github.com/Raku/nqp/releases/download/2023.12/nqp-2023.12.tar.gz"
  sha256 "d57ab0a4a592ddef10a4e6ed370f6ff81639e73d9f6b10f4ae15f26cf672593d"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "599a20cca3d9ad9ae254d241882ed01179df4b9782ee5923c8f98aae6e5bed7a"
    sha256 arm64_ventura:  "6e031dc9469cb3b5dc201deaa2898f618784a178376103527e979c8fd9c66543"
    sha256 arm64_monterey: "de1b5edfdd9658500596d986458a04ade5f12921f44d41b0f758a5bc3036d07d"
    sha256 sonoma:         "8cb047972c77fff3dbd4d564a70f0ddc40b073ece9319342c6b483a5cbe42ce1"
    sha256 ventura:        "be1b645006c0579ad87681383af390861210432c2d43696212edc4c7f8b9b871"
    sha256 monterey:       "b2e2e39f4afcb3a78e78648eee6e94392ef27ab07ecbd0af0f37615533373290"
    sha256 x86_64_linux:   "f4541801d5d1f2facf845ffef42101db4136700c69e2c65293ac4884ce0a70e1"
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
