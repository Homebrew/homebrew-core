class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_3.7.4.tar.gz"
  sha256 "f9f0e5267b26b3c8e683092df87159173b649e69bccfd1481cacd4d294398adf"
  license "CECILL-2.1"
  head "https://github.com/GreycLab/gmic.git", branch: "master"

  livecheck do
    url "https://gmic.eu/download.html"
    regex(/Latest\s+stable:.*?href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.t/im)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "27f92114ee4fca966d638137a1ab24c2ea52c084df442a0a7beddb59e3e7657d"
    sha256 cellar: :any,                 arm64_sequoia: "fed9100db6a833088c6959cc586c7f458c960ac7b76c2d9b7804e5002cadeb32"
    sha256 cellar: :any,                 arm64_sonoma:  "17c8d73d05b5f402ed7c140252bdac73c97f38873e75da0b20ca8f60d5d1ed91"
    sha256 cellar: :any,                 sonoma:        "569d26a83cc32f84cb5dfd25ca8967acaa2b6edfab4bf7f8e4ceac45fa0137f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8fa97dbd527bffbe73b66de5ef8c1e1a8b8981cbf8e8353500b6ae984189ad6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62346348f2570df11ef9c08068fcddf90bbf5d480abad4b7583b1787cd18d6a1"
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
