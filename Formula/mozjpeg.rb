class Mozjpeg < Formula
  desc "Improved JPEG encoder"
  homepage "https://github.com/mozilla/mozjpeg"
  url "https://github.com/mozilla/mozjpeg/archive/v4.0.0.tar.gz"
  sha256 "961e14e73d06a015e9b23b8af416f010187cc0bec95f6e3b0fcb28cc7e2cbdd4"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 "3009c242ebe825a0c9150839f62a92a8a317725f9411bbfe93a0881c8a7436eb" => :big_sur
    sha256 "b76cd545bd4829c589107a5c723086bda97d9060dd76d5b2626d45502b279487" => :arm64_big_sur
    sha256 "71f02633dddb7ea71193a7c21e1da0a6546fcd7c5ce10a725001b64aebf32a0f" => :catalina
    sha256 "4ddb9a3d5b4618528eae92f95d4b08090cfefe8797402aa27da0712ef7121a09" => :mojave
  end

  keg_only "mozjpeg is not linked to prevent conflicts with the standard libjpeg"

  depends_on "cmake" => :build
  depends_on "nasm" => :build
  depends_on "libpng"

  def install
    mkdir "build" do
      args = std_cmake_args - %w[-DCMAKE_INSTALL_LIBDIR=lib]
      system "cmake", "..", *args, "-DCMAKE_INSTALL_LIBDIR=#{lib}"
      system "make"
      system "make", "install"
    end
  end

  test do
    system bin/"jpegtran", "-crop", "1x1",
                           "-transpose", "-optimize",
                           "-outfile", "out.jpg",
                           test_fixtures("test.jpg")
  end
end
