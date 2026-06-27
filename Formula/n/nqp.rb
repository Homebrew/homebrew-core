class Nqp < Formula
  desc "Lightweight Raku-like environment for virtual machines"
  homepage "https://github.com/Raku/nqp"
  url "https://github.com/Raku/nqp/releases/download/2026.05/nqp-2026.05.tar.gz"
  sha256 "f43085635bcda97c6e4163e827bcca34e46840f72316126246b94bc04ab58ebf"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "d8569348a3fddba182b91c5aa4acd262862e6f5dbdebd4da1100720876a990a8"
    sha256 arm64_sequoia: "a6eb151c292c9ca6900d1f8f88590272f8baf1c0df04736fbb5d41981fcd0fed"
    sha256 arm64_sonoma:  "6e6391206d0fa27adb6af8e2ff726d9a72a41b9131e9aaa721b40616fe10fa4f"
    sha256 sonoma:        "e1fde449e09fb6af0f5dc0701b6c2bd10ca215ed5fb03e6f85fc4ffdc554af6b"
    sha256 arm64_linux:   "f6bbe8936a6930d336c11dceb244bdfb9f654bafc74f5643513d499667bd70a8"
    sha256 x86_64_linux:  "98bc3cb5b68ed77e6543289910705ffc06085c84d78a73973f2f71f285e31166"
  end

  depends_on "moarvm"

  uses_from_macos "perl" => :build

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
