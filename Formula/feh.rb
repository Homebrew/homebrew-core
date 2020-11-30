class Feh < Formula
  desc "X11 image viewer"
  homepage "https://feh.finalrewind.org/"
  url "https://feh.finalrewind.org/feh-3.6.tar.bz2"
  sha256 "87775d66a400e64a6c9866107c136355e67aec57e73b9e30137d0e46bf5fcfd8"
  license "MIT-feh"

  livecheck do
    url :homepage
    regex(/href=.*?feh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "c7a5d89a16c48875f86086727138758e36ebd24b3fbe2ec3263dfb1d4ef90fdf" => :big_sur
    sha256 "a61686d03a12eba87b4fbeb3d86a43cec6b90d957a1fc057d8798a4e90441c99" => :catalina
    sha256 "b804a510489cf592cd01130d666e46b5d803ef27d3b97b75ecda6c4a375b36ac" => :mojave
    sha256 "a3e0781f1800bb7da80dbd9142a69fb826047f137f012a5ab3890684e86c4ccd" => :high_sierra
  end

  depends_on "imlib2"
  depends_on "libexif"
  depends_on "libx11"
  depends_on "libxinerama"
  depends_on "libxt"

  def install
    system "make", "PREFIX=#{prefix}", "verscmp=0", "exif=1"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/feh -v")
  end
end
