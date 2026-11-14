class Nickle < Formula
  desc "Desk calculator language"
  homepage "https://www.nickle.org/"
  url "https://nickle.org/release/nickle-2.111.tar.xz"
  sha256 "e1f41c6a08aaf9fc283c282dfba6520fb621b02aaa58b40740d7b87bdad17870"
  license "MIT"

  livecheck do
    url "https://nickle.org/release/"
    regex(/href=.*?nickle[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "44fab039aee9e866362baa97316a364d0aae8f23f2998441e6da4cf812b5d69b"
    sha256 arm64_tahoe:       "8197a3be974c44633606c34146f2a32fd8fb3384c1bb2860dfa83b98e6693312"
    sha256 arm64_sequoia:     "1bec8fb2240f88503f2131ed9ec12b20ca1ad0978c57ebde5a9a6e4d0e013e01"
    sha256 arm64_linux:       "f4ac9a8a235117be9d4df3ef6f3de001dda1823eaeec6a8dc5794cf1a70ecad2"
    sha256 x86_64_linux:      "c7d6c6a87d4d6ac0a359c3185a771f133a44014b17f27c97a8255492ddd69041"
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
