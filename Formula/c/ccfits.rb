class Ccfits < Formula
  desc "Object oriented interface to the cfitsio library"
  homepage "https://heasarc.gsfc.nasa.gov/fitsio/CCfits/"
  url "https://heasarc.gsfc.nasa.gov/fitsio/CCfits/CCfits-2.6.tar.gz"
  sha256 "2bb439db67e537d0671166ad4d522290859e8e56c2f495c76faa97bc91b28612"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?CCfits[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8f1e70f55129b991cc5bb8035c8e0eb92901225984af325857cf7124180a2b02"
    sha256 cellar: :any,                 arm64_monterey: "5c222b5a44e8de98ffb844eaf585b718979f8e7a0f9f8ec0b3e34a74045310c1"
    sha256 cellar: :any,                 arm64_big_sur:  "17a553e7d2b1bd6ac44e54ab8a6cbb101a212d8732aeb785068d7fca13f6d431"
    sha256 cellar: :any,                 ventura:        "11c18cd3d891784215ce49c01335e936c4c7dad470b9354260b2a6cf0021750d"
    sha256 cellar: :any,                 monterey:       "9f88ac9b101bdb715eb5c17714a49850550485a74d4bd152c46b4085420c4da9"
    sha256 cellar: :any,                 big_sur:        "5567fdf74dea208531b63f0014da6f9b528beeaf58eeda3251f90f5b0fd4cba3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4e46548887f6794b6a28674f506071ed6070bc368c616086bb423b30301495e"
  end

  depends_on "cfitsio"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]

    # Remove references to brew's shims
    args << "pfk_cxx_lib_path=/usr/bin/g++" if OS.linux?

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
    assert_match "the answer is -11", shell_output("./test")
  end
end
