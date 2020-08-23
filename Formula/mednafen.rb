class Mednafen < Formula
  desc "Multi-system emulator"
  homepage "https://mednafen.github.io/"
  url "https://mednafen.github.io/releases/files/mednafen-1.24.3.tar.xz"
  sha256 "3dea853f784364557fa59e9ba11a17eb2674fc0fb93205f33bdbdaba1da3f70f"
  license "GPL-2.0"

  bottle do
    sha256 "b0d899239eba87b09c5a14c3cd8b539a8ae251304b5cccefbc192947fb299a19" => :catalina
    sha256 "43ad97110859253ce5dde1a3c2d0f947a16afb3f893852d15f055133dd8609e1" => :mojave
    sha256 "87a76e8115dbf4f4a4d7b4515e7b3d184f9a34ac916228fc98ac8cd5e1f090c8" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libsndfile"
  depends_on macos: :sierra # needs clock_gettime
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
