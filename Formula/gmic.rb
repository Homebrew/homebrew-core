class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_2.7.1.tar.gz"
  sha256 "c71e784abd2141252efad505b6a48b6974c388788db5530b3ca0dfb07baeafeb"
  head "https://github.com/dtschump/gmic.git"

  bottle do
    cellar :any
    sha256 "a8510f17aa4f57170b3afc337a26cde60d9b5a6daf6e0cfce07408fa0656781a" => :mojave
    sha256 "ef58052263cf42b8d19126872f77b591ef14891abb6057ed4b756c69eaa507ff" => :high_sierra
    sha256 "5042c3ee6211c25dd23708880e4c4261ab15445ed50aae7e58f8aee6eb56514b" => :sierra
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
  end
end
