class Mednafen < Formula
  desc "Multi-system emulator"
  homepage "https://mednafen.github.io/"
  url "https://mednafen.github.io/releases/files/mednafen-1.22.1.tar.xz"
  sha256 "f5b502e9f2f615c8b69fa1e151da20ab387377c72748cd8e19deb75a432ecfd2"

  bottle do
    sha256 "da5af9ae42a2b43ad3a5ce16cf16e8431540ca40cab4ef265a2dd8e1681106aa" => :mojave
    sha256 "288d8e4dd7ee68a50f5b18d245bdea6ace0b4b443ac243148d171f68a1d1715e" => :high_sierra
    sha256 "d0ce5c4a7cbcc62fd8fcc0dd47014db47374ceba78eeea8240c1d211ca2bcae6" => :sierra
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
