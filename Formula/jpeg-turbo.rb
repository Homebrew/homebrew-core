class JpegTurbo < Formula
  desc "JPEG image codec that aids compression and decompression"
  homepage "https://www.libjpeg-turbo.org/"
  url "https://downloads.sourceforge.net/project/libjpeg-turbo/2.0.3/libjpeg-turbo-2.0.3.tar.gz"
  sha256 "4246de500544d4ee408ee57048aa4aadc6f165fc17f141da87669f20ed3241b7"
  head "https://github.com/libjpeg-turbo/libjpeg-turbo.git"

  bottle do
    sha256 "8b1bebbe396aa8c87ffaf728e55206e6d87d431a1f26960e0043a4d314ecafaa" => :mojave
    sha256 "67e420053c229a4c33aaed0e6c585da8290b88c4fd6ca4e09d7c65c8d96656e8" => :high_sierra
    sha256 "196facd9c26ebc8cdc98f70c7b14b6b3c2271833fa664dcc1145101e9cb1312f" => :sierra
  end

  keg_only "libjpeg-turbo is not linked to prevent conflicts with the standard libjpeg"

  depends_on "cmake" => :build
  depends_on "nasm" => :build

  def install
    system "cmake", ".", "-DWITH_JPEG8=1", *std_cmake_args
    system "make"
    system "make", "test"
    system "make", "install"
  end

  test do
    system "#{bin}/jpegtran", "-crop", "1x1", "-transpose", "-perfect",
                              "-outfile", "out.jpg", test_fixtures("test.jpg")
  end
end
