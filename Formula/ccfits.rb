class Ccfits < Formula
  desc "Object oriented interface to the cfitsio library"
  homepage "https://heasarc.gsfc.nasa.gov/fitsio/CCfits/"
  url "https://heasarc.gsfc.nasa.gov/fitsio/CCfits/CCfits-2.6.tar.gz"
  sha256 "2bb439db67e537d0671166ad4d522290859e8e56c2f495c76faa97bc91b28612"

  livecheck do
    url :homepage
    regex(/href=.*?CCfits[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "95ebe7fe1047fc97a480395dedf612bf1220ed8fb3ddc2a33bad54bed196b7f8"
    sha256 cellar: :any,                 arm64_big_sur:  "93653ea8290192929bc4b61b468fa55e4e1435e67dea0d6b232751dc610126bd"
    sha256 cellar: :any,                 monterey:       "ca6b01bdf19a73d77314f6576524039f810c53782c20be03dc5da89873c54b0f"
    sha256 cellar: :any,                 big_sur:        "504f3e52451e700b4562dd91e5017587ebe829aa25421600bb8cb01ee2faa571"
    sha256 cellar: :any,                 catalina:       "fb2b7a32b1c881c91191aee126e556879184b2ac23a7c4dc62b88eb1328007af"
    sha256 cellar: :any,                 mojave:         "d7111f916b0ee822f04fe233d00c5e66c151bd821a9ba8fc52365c2270e37fa7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ec9d494a486df7902b5848cfcc17479f3daa752fd164b0424ca15f0cb7e6c32"
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
