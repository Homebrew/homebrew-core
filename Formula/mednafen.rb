class Mednafen < Formula
  desc "Multi-system emulator"
  homepage "https://mednafen.github.io/"
  url "https://mednafen.github.io/releases/files/mednafen-1.24.1.tar.xz"
  sha256 "a47adf3faf4da66920bebb9436e28cbf87ff66324d0bb392033cbb478b675fe7"

  bottle do
    sha256 "05d5e089426ad7855d7676b98cddd627bd4c0d9c1805612e3bcd7e9d4667c6c8" => :catalina
    sha256 "8f424aa04340125fe6b0556bc8554a145b43e4f7319b316f3179794628ccf40d" => :mojave
    sha256 "99b51ff663598acb7a178119a1510bf86f1d1002960f7b6c121911eec618650b" => :high_sierra
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
