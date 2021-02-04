class Ccfits < Formula
  desc "Object oriented interface to the cfitsio library"
  homepage "https://heasarc.gsfc.nasa.gov/fitsio/CCfits/"
  url "https://heasarc.gsfc.nasa.gov/fitsio/CCfits/CCfits-2.5.tar.gz"
  sha256 "938ecd25239e65f519b8d2b50702416edc723de5f0a5387cceea8c4004a44740"
  revision 2

  bottle do
    sha256 cellar: :any, arm64_big_sur: "957e2589c467c78c2e134476b0fe123d470a3e402e37ddef27965d706c1fdbe7"
    sha256 cellar: :any, big_sur:       "c15ddcdce98436a8c8dfb72a43586d23061b7199953aec9b1b5a0a2c544eb1d0"
    sha256 cellar: :any, catalina:      "bcf673522fe7245b6ca8c93139793acf10c0fb3e351de96cfd634e296a5be813"
    sha256 cellar: :any, mojave:        "22aa452875d79f09825a87f9f3e384552e7fd92e5d954cd361a1b92cd9e52513"
    sha256 cellar: :any, high_sierra:   "b527e857acac1d749786f44a06af0cfa5f19f34c568c5f21c65675fa04b97f26"
  end

  depends_on "cfitsio"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]
    on_linux do
      # Remove references to brew's shims
      args << "pfk_cxx_lib_path=/usr/bin/g++"
    end
    system "./configure", *args
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
