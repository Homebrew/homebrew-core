class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_2.9.1.tar.gz"
  sha256 "50c9dd418b8d0e80c703c2e2b179b6049343567483d37d9ff6c642c6ede95d8d"
  license "CECILL-2.1"
  head "https://github.com/dtschump/gmic.git"

  bottle do
    cellar :any
    sha256 "183c99cebc7e117f17d258c875e859aad64f0d2b4837386fb76be23341f9ff95" => :catalina
    sha256 "32903db189cdbbc67e0445786b483d3266c36033e4ea9ac4473972844460dc37" => :mojave
    sha256 "c012e70fb7185d12e44fbb64e1a27dcaaad6089c57a7b8862fb984c66b32eeee" => :high_sierra
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
