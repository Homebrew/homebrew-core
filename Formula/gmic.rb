class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_3.0.1.tar.gz"
  sha256 "6cc20a20e3ab53ce485ccf6e044a30141b3d62cf7743b83bb04906ff29453035"
  license "CECILL-2.1"
  head "https://github.com/dtschump/gmic.git", branch: "master"

  livecheck do
    url "https://gmic.eu/files/source/"
    regex(/href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e8f6c441ac6b3e796b59aad218fcea2f56a3cfd7c09c15c4ae26f298dc9ec410"
    sha256 cellar: :any,                 arm64_big_sur:  "593910f6919dc9c3d44bbdaf33753bd43599b145fc642bc231c5fce86641a751"
    sha256 cellar: :any,                 monterey:       "d258b18ba0ccc52c99d20b072a42ff4d1a7384d4e0cc4999316f5821d677ccb2"
    sha256 cellar: :any,                 big_sur:        "83abc77386f2109c94d6e4ca116024d2202b71df81353a6b544930d6916a417c"
    sha256 cellar: :any,                 catalina:       "21f90efe4a38f46ebbbaa448320abe5f77cc70c40587e51bed4afe843b9757d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4af560b960d2dc3e7480f82edde6eebc21577ef1eba30825f201f020bfc07c4"
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
