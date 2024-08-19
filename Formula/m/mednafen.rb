class Mednafen < Formula
  desc "Multi-system emulator"
  homepage "https://mednafen.github.io/"
  url "https://mednafen.github.io/releases/files/mednafen-1.32.1.tar.xz"
  sha256 "de7eb94ab66212ae7758376524368a8ab208234b33796625ca630547dbc83832"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://mednafen.github.io/releases/"
    regex(/href=.*?mednafen[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "b72bcc13e2b1d434445671be362e53a972a3a0c87cc891eb1fcdb10f4ed248ad"
    sha256 arm64_ventura:  "6c642b401c177c0f9afe5c2676c2aa1fcffc0eba991db44fc446494e87ea4641"
    sha256 arm64_monterey: "6ee3639bd5e939d6438c536e2505724710d3f2d09ca4d251019fe3db330eec80"
    sha256 sonoma:         "3b70d0a28be268ef8799149e20d3ea2dac1f75d9b5afbb56771eee373dc931c6"
    sha256 ventura:        "0944ef9b874ae58c2263e3dc87f4f64151ec08fdfec7fcac7a65e1c6c2354495"
    sha256 monterey:       "961f06c1b8a639e416bdbe6c39b96a47abfd6fafc11c0cef11ff4f3641e4c8d6"
    sha256 x86_64_linux:   "2b0e225a4706c1e3667c25ffa52181a63a97b2dad8e9d2f8520adbdcf1a5eb0f"
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
