class Ccfits < Formula
  desc "Object oriented interface to the cfitsio library"
  homepage "https://heasarc.gsfc.nasa.gov/fitsio/CCfits/"
  url "https://heasarc.gsfc.nasa.gov/fitsio/CCfits/CCfits-2.5.tar.gz"
  sha256 "938ecd25239e65f519b8d2b50702416edc723de5f0a5387cceea8c4004a44740"

  bottle do
    cellar :any
    sha256 "fb3837dfbbd911a58b7ebddcc070c4ce00a1831c6587d2f8d402173a05dc1215" => :catalina
    sha256 "bfd31cbc94ceba181a2267253516f4d76d77679f21aaf36a75892b3dd4afd8a1" => :mojave
    sha256 "450c0b713f2ec2bc9a1b6ba9c4a2905f2b818fa4d143cf4b93d0031e0f7f357f" => :high_sierra
  end

  depends_on "cfitsio"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <CCfits/CCfits>
      #include <iostream>
      int main() {
        CCfits::FITS::setVerboseMode(true);
        std::cout << "the answer is " << CCfits::VTbyte << std::endl;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", "-I#{include}",
                    "-L#{lib}", "-lCCfits"
    assert_match /the answer is -11/, shell_output("./test")
  end
end
