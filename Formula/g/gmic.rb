class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_3.7.5.tar.gz"
  sha256 "159d15a5b6fcd6cf1da676ef971a3fd4ebeadc8d1c009c0f9275c2af4034e5e4"
  license "CECILL-2.1"
  head "https://github.com/GreycLab/gmic.git", branch: "master"

  livecheck do
    url "https://gmic.eu/download.html"
    regex(/Latest\s+stable:.*?href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.t/im)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "13500457661b11996af6f04579566b8ff55ac3a957b24565d5e455c0cee8c8cd"
    sha256 cellar: :any,                 arm64_sequoia: "7536bcec01363a8e4e3809fbc301acdaadc96f7b9a357f537333b13669c05487"
    sha256 cellar: :any,                 arm64_sonoma:  "c336a1fc2b3304bfa8ab7c6e497630d8c7df8047993cd5acb3bd3a4c6b47ffd3"
    sha256 cellar: :any,                 sonoma:        "0aaf51519e865e34a481125c7d1eb489f441e9ebec359a5c6381f23ebbc57f3f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d77a320dad996477c0adbe2d225f49fd99b7df4a3895e6a0cc7950101d7dce2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3a96c231087990f8d4f3708fabf0e5e46a7e8442e379bc42341d305dbb444f8"
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

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "libx11"
    depends_on "zlib-ng-compat"
  end

  def install
    rm "src/CImg.h" if build.stable?

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
