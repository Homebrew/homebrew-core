class Pngquant < Formula
  desc "PNG image optimizing utility"
  homepage "https://pngquant.org/"
  url "https://pngquant.org/pngquant-2.13.1-src.tar.gz"
  sha256 "4b911a11aa0c35d364b608c917d13002126185c8c314ba4aa706b62fd6a95a7a"
  license :cannot_represent
  head "https://github.com/kornelski/pngquant.git"

  livecheck do
    url "https://pngquant.org/releases.html"
    regex(%r{href=.*?/pngquant[._-]v?(\d+(?:\.\d+)+)-src\.t}i)
  end

  bottle do
    cellar :any
    sha256 "ac9a63953788be2e15e1215b32f3280dcaa4beaebeae7f239247616d9186f7d8" => :big_sur
    sha256 "cad350e78adc1912e1895b2f1c4abaf27bd14db902bad179424580934b9e1a05" => :catalina
    sha256 "60f111e8252d2480df50d6fc77e2938c50480dc03e00207a75033b882cbeb740" => :mojave
    sha256 "eb2b662bda1612dece961a7809ea5336997a00354fe204a001b4191b5b658fed" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libpng"
  depends_on "little-cms2"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/pngquant", test_fixtures("test.png"), "-o", "out.png"
    assert_predicate testpath/"out.png", :exist?
  end
end
