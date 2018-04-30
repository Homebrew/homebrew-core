class Mednafen < Formula
  desc "Multi-system emulator"
  homepage "https://mednafen.github.io/"
  url "https://mednafen.github.io/releases/files/mednafen-1.21.3.tar.xz"
  sha256 "2e761e8834b098b7f1ab35dccaa6d2be715ee9106cf40af4919f6ca4b99ee3c6"

  bottle do
    sha256 "ba2295e65433001d24d1001638aeb86565467d6ca690105c9382c4573766c42c" => :high_sierra
    sha256 "88644723477cfc5087df7b8d7f386fd4c85b70fb7d15616277de742ea3921ac6" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "sdl2"
  depends_on "libsndfile"
  depends_on :macos => :sierra # needs clock_gettime
  depends_on "gettext"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    cmd = "#{bin}/mednafen | head -n1 | grep -o '[0-9].*'"
    assert_equal version.to_s, shell_output(cmd).chomp
  end
end
