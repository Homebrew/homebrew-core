class Mednafen < Formula
  desc "Multi-system emulator"
  homepage "https://mednafen.github.io/"
  url "https://mednafen.github.io/releases/files/mednafen-1.29.0.tar.xz"
  sha256 "da3fbcf02877f9be0f028bfa5d1cb59e953a4049b90fe7e39388a3386d9f362e"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url "https://mednafen.github.io/releases/"
    regex(/href=.*?mednafen[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "46497ce4ed8f15cbd87f47ae217299b0e7335e7a2c23c7b530bfabdd0059d71b"
    sha256 arm64_big_sur:  "ed468b186353eb0ad71c36a49388cade47fc2636d2ee30ec358209638ec31bee"
    sha256 monterey:       "521859a49df7733c5049d673e8f5bb54e4ae063c26eb58484fe29fb1561e611c"
    sha256 big_sur:        "e5e790528b981bf9da07c3017f05cf3eaa16151609a76d780e45d9d7710995b5"
    sha256 catalina:       "58fbb821874164c2a0017a09a0693e8090972300cba974fa57c7f8486941d25e"
    sha256 x86_64_linux:   "f24de2c8d65dfc7c2cea862da3fe9b0da7d875e3cb6b7afac422ee4c12bb01cb"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libsndfile"
  depends_on "lzo"
  depends_on macos: :sierra # needs clock_gettime
  depends_on "sdl2"
  depends_on "zstd"

  uses_from_macos "zlib"

  on_macos do
    # musepack is not bottled on Linux
    # https://github.com/Homebrew/homebrew-core/pull/92041
    depends_on "musepack"
  end

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    args = std_configure_args
    args << "--with-external-mpcdec" if OS.mac? # musepack

    system "./configure", "--with-external-lzo",
                          "--with-external-libzstd",
                          "--enable-ss",
                          *args
    system "make", "install"
  end

  test do
    # Test fails on headless CI: Could not initialize SDL: No available video device
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    cmd = "#{bin}/mednafen | head -n1 | grep -o '[0-9].*'"
    assert_equal version.to_s, shell_output(cmd).chomp
  end
end
