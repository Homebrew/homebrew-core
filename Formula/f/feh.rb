class Feh < Formula
  desc "X11 image viewer"
  homepage "https://feh.finalrewind.org/"
  url "https://feh.finalrewind.org/feh-3.13.1.tar.bz2"
  sha256 "785cd3bf51e05f6bb86ab0d649b7ed20e31892eb635bc5a25c963bf934088445"
  license "MIT-feh"

  livecheck do
    url :homepage
    regex(/href=.*?feh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "360d1466646f27866e144c886dca69a4a568d1b75e1cbf05c672329ae91e1c91"
    sha256 arm64_tahoe:       "46ef1f9f762e8bd2ba0077408ba00e5e952eaebb72167940e830501931e3a66d"
    sha256 arm64_sequoia:     "913591bd7662f4d6097be1fb66255af9f912bd79a0c9e5fa1cb4be2a9494f3b3"
    sha256 arm64_linux:       "8181d653eba7264cdaa72786f735fac24aa30e3d841a3326debcdc9770f37d6a"
    sha256 x86_64_linux:      "d45fb5284f44125499f4a0dd2aa2184c7bdf28b3b91564c17d8bacf878fa603a"
  end

  depends_on "imlib2"
  depends_on "libexif"
  depends_on "libpng"
  depends_on "libx11"
  depends_on "libxinerama"
  depends_on "libxt"

  uses_from_macos "curl"

  def install
    system "make", "PREFIX=#{prefix}", "verscmp=0", "exif=1"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/feh -v")
  end
end
