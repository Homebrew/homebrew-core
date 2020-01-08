class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_2.8.1.tar.gz"
  sha256 "1a2b4c75c428201e52e920bd07e6c04118ae294cb89fce3c1c4ef386421b2a7a"
  revision 1
  head "https://github.com/dtschump/gmic.git"

  bottle do
    cellar :any
    sha256 "8c84dd3859b104dda7b701de6ac595c11b23ab34fd99f90dca3a4ded80a8ba34" => :catalina
    sha256 "dc8d5647e0bfadbfeb6e8cbec7a6bfbff5442987a5d0c4b492398860370312b6" => :mojave
    sha256 "1f50e9f137f3f50219799b5db1416f2464e6b161e69bd17cedb25c0bdbe9957f" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "fftw"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"

  def install
    system "cmake", *std_cmake_args,
                    "-DENABLE_FFMPEG=OFF",
                    "-DENABLE_OPENCV=OFF",
                    "-DENABLE_OPENEXR=OFF",
                    "-DENABLE_X=OFF"
    system "make", "install"
  end

  test do
    %w[test.jpg test.png].each do |file|
      system bin/"gmic", test_fixtures(file)
    end
    system bin/"gmic", "-input", test_fixtures("test.jpg"), "rodilius", "10,4,400,16",
           "smooth", "60,0,1,1,4", "normalize_local", "10,16", "-output", testpath/"test_rodilius.jpg"
    assert_predicate testpath/"test_rodilius.jpg", :exist?
  end
end
