class Hp2xx < Formula
  desc "Converts HPGL Plotter language to other vector & raster graphics formats."
  homepage "https://www.gnu.org/software/hp2xx/"
  url "https://ftpmirror.gnu.org/hp2xx/hp2xx-3.4.4.tar.gz"
  sha256 "47b72fb386a189b52f07e31e424c038954c4e0ce405803841bed742bab488817"

  depends_on "libpng12"
  depends_on :x11

  def install
    system "make"
    system "make", "install"
  end

  test do
    system "true"
  end
end
