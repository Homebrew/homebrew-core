class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_2.8.4.tar.gz"
  sha256 "b2a279bdf981595b30d8d7828fabf9a620cde06eae8db345a8cddf2160c25379"
  head "https://github.com/dtschump/gmic.git"

  bottle do
    cellar :any
    sha256 "5aef6b7e3b76d32c04cd933ae481e5cae0c18d9ff2afbc8e856fa868e13226f7" => :catalina
    sha256 "c19575e70d1cb12bd34f9259044fe39ef2c721dea7427b0b14d536cde5583f5d" => :mojave
    sha256 "a1b66c385e526bc6f4d1c07fa39717845cf708b7908dbef9c5bc119ad1f3b9d2" => :high_sierra
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
