class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_2.9.0.tar.gz"
  sha256 "6233695f9b27999dcc7cc3aa7480b0f192bd44de85209091a3b4b8a65ae8c4b5"
  head "https://github.com/dtschump/gmic.git"

  bottle do
    cellar :any
    sha256 "678d3b2bb8b2856fd9d5fee27a1c3215ee91a725265629bc1cfd398865d0ef75" => :catalina
    sha256 "953591c5716c663fccb97bbd10b0c2367ff4b790d5f3d721288489913ecf5ef2" => :mojave
    sha256 "34ecec0346606ac9048ebbc8315e1f8c72325782512c29bf1c10464a5d3e906b" => :high_sierra
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
