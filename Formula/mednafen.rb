class Mednafen < Formula
  desc "Multi-system emulator"
  homepage "https://mednafen.github.io/"
  url "https://mednafen.github.io/releases/files/mednafen-1.22.2.tar.xz"
  sha256 "fad433ac694696d69ea38f6f4be1d0a6c1aa3609ec7f46ce75412be2f2df2f95"

  bottle do
    sha256 "3f76cf3b0e73253f75e869d3609515ddbb134de52aaeac6e897894a380544e65" => :mojave
    sha256 "35c60b66fa52ec6607879bb58344e6876c5a0311dac931d66aff47f8e35a16a0" => :high_sierra
    sha256 "52da73bee0b92c80e23be9f3585ee5eccfb4f3daf92fe604855fd047a10b823b" => :sierra
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
