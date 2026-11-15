class Nickle < Formula
  desc "Desk calculator language"
  homepage "https://www.nickle.org/"
  url "https://nickle.org/release/nickle-2.113.tar.xz"
  sha256 "994e5658cab6aa9525a52ac38d220d26854808b4afdfec0beac0840325433d17"
  license "MIT"

  livecheck do
    url "https://nickle.org/release/"
    regex(/href=.*?nickle[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "a432ba1d041114b2e84166d881838b291e9f02591d721b989db3f7ecdc4c3c86"
    sha256 arm64_tahoe:       "4c62dc52dab4f15f4a2ff7f185a7f4d66d561ee5f5d2de5b3f78c0e823d4a9fb"
    sha256 arm64_sequoia:     "424827ea51c87fea9da1d4ebe2670f9ddf1c8426f939a9fcf6b674b0db8ae544"
    sha256 arm64_linux:       "afe26ff8caad3a6c823e3f0dc22d3fb3c2cf966a91b81e69068a375fd12e61e9"
    sha256 x86_64_linux:      "20713e7ab583d25dc5e1850f59b8e3aa47083e27b74e26f567bf81af8bc2f6a3"
  end

  depends_on "bison" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "gmp"

  uses_from_macos "bc-gh" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "libedit"

  # Remove an unused declaration that conflicts with Flex's input function.
  patch do
    url "https://github.com/keith-packard/nickle/commit/1d319e603813f3a78ec83440584a901d603346e8.patch?full_index=1"
    sha256 "04828738e17813ebd5fd9aa9e38a549f2b5de9a707bdf1b6ae062c5d5d1388b9"
    type :unofficial
    resolves "https://github.com/keith-packard/nickle/pull/1"
  end

  def install
    # Fix to ERROR: None of values ['gnu23'] are supported by the C compiler
    inreplace "meson.build", "c_std=gnu23", "c_std=gnu2x"

    system "meson", "setup", "build", "-Dlibedit=true", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_equal "4", shell_output("#{bin}/nickle -e '2+2'").chomp
  end
end
