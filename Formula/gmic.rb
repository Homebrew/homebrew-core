class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_2.9.6.tar.gz"
  sha256 "d22fe8515af16dcd050d09a0bc7127ec29f4795ce732a0c6c3eaf839356bc11a"
  license "CECILL-2.1"
  head "https://github.com/dtschump/gmic.git"

  livecheck do
    url "https://gmic.eu/files/source/"
    regex(/href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "380909ea88da30b0856aa10d49ba0b18a9bb0fea7b8d7c0cdf367350637bd26c"
    sha256 cellar: :any, big_sur:       "219e808f8c9dbc0bb20b20ef439f240fc08a4e178fb8bc4619d0e2b491fc07b0"
    sha256 cellar: :any, catalina:      "ce99930d878f95408ce99a5e9e7fd72ece798305a539b506e7a0e94fd9a537f2"
    sha256 cellar: :any, mojave:        "fa27bf088d59ec3068a95df070a8d3f7261b4b1f22b8fc01935200047936d056"
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
