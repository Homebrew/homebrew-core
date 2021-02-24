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
    sha256 cellar: :any, arm64_big_sur: "bd18f4f2e8557ca15a3934979359a475c18480beb84efbff3da7a57be0de71e6"
    sha256 cellar: :any, big_sur:       "1949476d0f283e41c00bf4f13a149ddaf4937fa55d009cd0ac1516e7658b5cbd"
    sha256 cellar: :any, catalina:      "41cbbf00a1243f39d8d04aecde7c03fae52e8b5ea6bba4ed1a7cef2f75ca5dad"
    sha256 cellar: :any, mojave:        "9ba5b0bdd609d95dd3bb2387316ea6bcc913f05baad6189cc32388ecc4544a59"
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
