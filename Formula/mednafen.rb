class Mednafen < Formula
  desc "Multi-system emulator"
  homepage "https://mednafen.github.io/"
  url "https://mednafen.github.io/releases/files/mednafen-1.29.0.tar.xz"
  sha256 "da3fbcf02877f9be0f028bfa5d1cb59e953a4049b90fe7e39388a3386d9f362e"
  license "GPL-2.0-or-later"
  revision 3

  livecheck do
    url "https://mednafen.github.io/releases/"
    regex(/href=.*?mednafen[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "9096c00e39b4ca7cf5180f4afc46e607f38314336bc591e24723171adebb81b4"
    sha256 arm64_monterey: "59e6b6f8f9d8797c87b78a7d80d41a75375cec35123e574406f80d8e0464a06c"
    sha256 arm64_big_sur:  "48a7df09b1d9e6244883287fe1ba28cfcb73b94b4d4ca40b90aeda35a0d076d0"
    sha256 ventura:        "3dcedcf3c6042e2993a5153dcc530c8c4f58b962fc3b3c549a4c1b8b02aa775e"
    sha256 monterey:       "0d17cda29047b8b86656601227e40e678e358cac1a8acb60841e31c1f96ca4a8"
    sha256 big_sur:        "e04c8f424849bf8afdfd1bfa55e7f768f87ddb5dcd9449543ecb39a9d8cc7c72"
    sha256 catalina:       "558b3492c6a264effc024be0462fd05f60d94d78ad20cf117b84256fa47a8969"
    sha256 x86_64_linux:   "c72f67035b985636b2d6e0c204f6218e43575b6c20d22e547b9516706d4310c5"
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
