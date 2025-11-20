class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_3.6.3.tar.gz"
  sha256 "45304f179f2200ba527c819bd911bd6a85c4a4999740c730c7ccdd164ce240ac"
  license "CECILL-2.1"
  head "https://github.com/GreycLab/gmic.git", branch: "master"

  livecheck do
    url "https://gmic.eu/download.html"
    regex(/Latest\s+stable:.*?href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.t/im)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ea1a589fd75900336c327d3fa413d4e9bd1216f651d770803ed6d75afee928bb"
    sha256 cellar: :any,                 arm64_sequoia: "5c72f1fe55a9e78bc81b439385f9224d5e387ff121adda3c0f77a5592fa5f93c"
    sha256 cellar: :any,                 arm64_sonoma:  "c50dd5bf3f24272e79f58eee4bf50ec5196de4f042d8f312839ea401546a6b7e"
    sha256 cellar: :any,                 sonoma:        "d4cef90e80766fa703aa10e73b2887f0490af7006fc311b762aa6cd6588b281a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "060c1e616e887145592f09a431503313aa1e8c6f6733eed9f83e6ea6191275d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc5e883d2f5dd0d8db5aeafbf322d0ed2740898ea13f2dca80118b3949a6ece3"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "cimg"
  depends_on "fftw"
  depends_on "imath"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openexr"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libx11"
  end

  def install
    args = %W[
      -DCMAKE_EXE_LINKER_FLAGS=-Wl,-rpath,#{rpath}
      -DENABLE_DYNAMIC_LINKING=ON
      -DENABLE_FFMPEG=OFF
      -DENABLE_GRAPHICSMAGICK=OFF
      -DUSE_SYSTEM_CIMG=ON
    ]
    if OS.mac?
      args << "-DENABLE_X=OFF"
      inreplace "CMakeLists.txt", "COMMAND LD_LIBRARY_PATH", "COMMAND DYLD_LIBRARY_PATH"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    %w[test.jpg test.png].each do |file|
      system bin/"gmic", test_fixtures(file)
    end
    system bin/"gmic", "-input", test_fixtures("test.jpg"), "rodilius", "10,4,400,16",
           "smooth", "60,0,1,1,4", "normalize_local", "10,16", "-output", testpath/"test_rodilius.jpg"
    assert_path_exists testpath/"test_rodilius.jpg"
  end
end
