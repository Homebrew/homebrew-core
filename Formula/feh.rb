class Feh < Formula
  desc "X11 image viewer"
  homepage "https://feh.finalrewind.org/"
  url "https://feh.finalrewind.org/feh-3.7.1.tar.bz2"
  sha256 "57ab1ca61f57c96595878069f550d36f518530f88fa31b74cc39cd739f9258b6"
  license "MIT-feh"

  livecheck do
    url :homepage
    regex(/href=.*?feh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "08ce9eb5ac25166311d929dbbef66a543934f610767d5e89f59345464414aa9a"
    sha256 big_sur:       "9f5578b737f72644365e9f5e0135bbc28657087584888f66864a452b6c034c3d"
    sha256 catalina:      "7d5a0033554e7ccc69901c40f3385386ce597915ecd39cd43774f952eb60f9f4"
    sha256 mojave:        "fcb14423edc7a7070f547fe0878f473c9399b23868317be1a1ea18ac85d6e085"
    sha256 x86_64_linux:  "f2aa45fd63df563855826e20371aa94053dfc5c1b612027532c0de7fafdac2d5"
  end

  depends_on "imlib2"
  depends_on "libexif"
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
