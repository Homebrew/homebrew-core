class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_2.9.7.tar.gz"
  sha256 "942537487ea722141230579db3cd4331368429c0e33cb38fee1b17aae9557f16"
  license "CECILL-2.1"
  head "https://github.com/dtschump/gmic.git"

  livecheck do
    url "https://gmic.eu/files/source/"
    regex(/href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "2a684946ab82b40f48894bac5628fd568555c79e412154415149c559b8855439"
    sha256 cellar: :any, big_sur:       "fa3a9f34a4e6af5756037d3d0085cc95192fd2cf133e14985cd98314b46c0d2d"
    sha256 cellar: :any, catalina:      "28d193071d9c956bb8002584cbd7e9439cb3b4fbbce4fb37106345dfcc3898e8"
    sha256 cellar: :any, mojave:        "8a24235a837b3972a6f8b39b3ca219e676c7807ed83daf613576f1acb813faa2"
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
