class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_2.9.4.tar.gz"
  sha256 "790bee48f496765f6b59067dfb10dc34e1eb576caf9a95f30af0d567026eacc7"
  license "CECILL-2.1"
  head "https://github.com/dtschump/gmic.git"

  livecheck do
    url "https://gmic.eu/files/source/"
    regex(/href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "07a3a4f6bb1cff27c8096ddafe4771732ea3b34c4357e063b26a793b045d34a8" => :big_sur
    sha256 "dc7bf43f4c5b00c16791a9f0d8054cf8ccba5135644ddc3bb4fe1450c4b76cb5" => :arm64_big_sur
    sha256 "a9ea834115206f83414613cd78821216024f50b3ae68f15f0b1b3971ce9f3069" => :catalina
    sha256 "e924a500c6fdb64cb17f4eb0ec6dfa72dcef242d6ffabac1c914e3c15862494f" => :mojave
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
