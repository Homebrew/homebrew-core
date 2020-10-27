class Feh < Formula
  desc "X11 image viewer"
  homepage "https://feh.finalrewind.org/"
  url "https://feh.finalrewind.org/feh-3.5.tar.bz2"
  sha256 "388f9dcc8284031023364355e23a82c276e79ca614f2dcd64d2f927857a4531e"
  license "MIT-feh"

  livecheck do
    url :homepage
    regex(/href=.*?feh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "9ab3087cc24d59b54e032dd37f6d04ab367f6b4121576bd0c969303e9a341b35" => :catalina
    sha256 "9240eda39c189b0c0c78d4cc53f11642dec23ea9e58b899ede9fa7dec5101a30" => :mojave
    sha256 "e73c73c598430c28f998b14191009c237668c17e71f9ce4f32686e504bb21111" => :high_sierra
  end

  depends_on "imlib2"
  depends_on "libexif"
  depends_on :x11

  def install
    system "make", "PREFIX=#{prefix}", "verscmp=0", "exif=1"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/feh -v")
  end
end
