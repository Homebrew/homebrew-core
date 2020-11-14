class Mednafen < Formula
  desc "Multi-system emulator"
  homepage "https://mednafen.github.io/"
  url "https://mednafen.github.io/releases/files/mednafen-1.26.1.tar.xz"
  sha256 "842907c25c4292c9ba497c9cb9229c7d10e04e22cb4740d154ab690e6587fdf4"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://mednafen.github.io/releases/"
    regex(/href=.*?mednafen[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

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
