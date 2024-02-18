class Nqp < Formula
  desc "Lightweight Raku-like environment for virtual machines"
  homepage "https://github.com/Raku/nqp"
  url "https://github.com/Raku/nqp/releases/download/2024.01/nqp-2024.01.tar.gz"
  sha256 "780cefef012dc457c1766e45397810f8261d7ff26c1e056da64a8893cd99f89e"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "70e0d91cf20d1ded08f046d9e4d57fb76dcb009da2430e07ac813c3e494b1140"
    sha256 arm64_ventura:  "bcc02f2118be3a7e82a7d3d96508e3d971a130a21b9e94b92d4c86de07718f85"
    sha256 arm64_monterey: "f1622eed8d9899f22d272d3f1f0afaa61ac8951b503abdc8a59b3473a5fbdf69"
    sha256 sonoma:         "e541e0638a3cd11776f8d4797cb85d7b13b492194255beb98aaf752365369c91"
    sha256 ventura:        "cf108b643164a6414bac3435879d93bad2c81f7285d98572d11a070ba6a4f479"
    sha256 monterey:       "d79ef607bf8fd4c2037b73009ac26cf041c70f64933fa0351b3b3c2c811559ed"
    sha256 x86_64_linux:   "1e043063c1e12892530dcd5d3adb6ab694c18f9b10a64988da051b22b34ca1a5"
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
