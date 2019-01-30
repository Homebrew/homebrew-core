class Mednafen < Formula
  desc "Multi-system emulator"
  homepage "https://mednafen.github.io/"
  url "https://mednafen.github.io/releases/files/mednafen-1.22.1.tar.xz"
  sha256 "f5b502e9f2f615c8b69fa1e151da20ab387377c72748cd8e19deb75a432ecfd2"

  bottle do
    sha256 "1817b1b46cc5e573d9719d5619e9e78b8ea4e9bfbe7d911b808ddcefbd5a701f" => :mojave
    sha256 "d4e4e7db27ba03192573ffd25cc1001aa6fee082c125f0aed68aebf6c84068f3" => :high_sierra
    sha256 "ff2cdee178008a503e56b4ea5d607d4bee39360232c220eeda0f4fb572dbad92" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libsndfile"
  depends_on :macos => :sierra # needs clock_gettime
  depends_on "sdl2"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    cmd = "#{bin}/mednafen | head -n1 | grep -o '[0-9].*'"
    assert_equal version.to_s, shell_output(cmd).chomp
  end
end
