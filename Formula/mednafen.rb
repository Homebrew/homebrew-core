class Mednafen < Formula
  desc "Multi-system emulator"
  homepage "https://mednafen.github.io/"
  url "https://mednafen.github.io/releases/files/mednafen-1.22.1.tar.xz"
  sha256 "f5b502e9f2f615c8b69fa1e151da20ab387377c72748cd8e19deb75a432ecfd2"
  revision 1

  bottle do
    sha256 "8f21a00e4bc5c3bf8d053f393c2fe5aedb3225259bce7846297d36e3ce25c144" => :mojave
    sha256 "912f607423d94da528b1b1c6b8dd26ff97f1bec992e7b3a99fbd5eed9830a5eb" => :high_sierra
    sha256 "dcba8476cd955867380598cfb9cd064a6832103d339ea53a71d8c41bd51093f5" => :sierra
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
