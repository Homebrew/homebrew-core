class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_3.3.5.tar.gz"
  sha256 "052456e0d9dd6a3c1e102a857ae32150ee6d5cb02a1d2f810c197ec490e56c1b"
  license "CECILL-2.1"
  head "https://github.com/GreycLab/gmic.git", branch: "master"

  livecheck do
    url "https://gmic.eu/download.html"
    regex(/Latest\s+stable:.*?href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.t/im)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "423f97ef38164621dc904d4783dc327f65d5d3428ba4c911a928de54c77c7a42"
    sha256 cellar: :any,                 arm64_ventura:  "bd1fd2a455bb56b62e2bab5ac8380826e6f0b6dd2dc710bb546aac6bc5d6c0e4"
    sha256 cellar: :any,                 arm64_monterey: "77035a3113827bcb85d23fc417ce0da4180475545fa7baab9aa5c4fab5b3c2fc"
    sha256 cellar: :any,                 sonoma:         "684226bd9b88de8dfb371bb1692f8091833ada283adae2357b722520a309bb15"
    sha256 cellar: :any,                 ventura:        "f5352ddb96b2c1a6997c70f8637cd3180153db1e676768e78572d4fd4c2b59ed"
    sha256 cellar: :any,                 monterey:       "048c584f771f173a29bdb41a0da31f1915d520769456fed9e2bb3d27ff93a649"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a65fcd384a17292da8fe3f60078b5ad037325a8661010a9fded0ad94d024327"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "cimg"
  depends_on "fftw"
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
    assert_predicate testpath/"test_rodilius.jpg", :exist?
  end
end
