class Mednafen < Formula
  desc "Multi-system emulator"
  homepage "https://mednafen.github.io/"
  url "https://mednafen.github.io/releases/files/mednafen-1.22.2.tar.xz"
  sha256 "fad433ac694696d69ea38f6f4be1d0a6c1aa3609ec7f46ce75412be2f2df2f95"

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
