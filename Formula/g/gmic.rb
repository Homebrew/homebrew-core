class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_3.6.1.tar.gz"
  sha256 "4cf36b7af48013651e40e2c17be646b748cffdd400a90562588a35af731f6c9e"
  license "CECILL-2.1"
  revision 1
  head "https://github.com/GreycLab/gmic.git", branch: "master"

  livecheck do
    url "https://gmic.eu/download.html"
    regex(/Latest\s+stable:.*?href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.t/im)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c94f341bc01b6089f78177f30b627d0613b262a8b3449026ddb169d82ed606ce"
    sha256 cellar: :any,                 arm64_sequoia: "05ada69a02777ae811103cc52fd51fad1f4d33147d497b21c97f3eec599f1f15"
    sha256 cellar: :any,                 arm64_sonoma:  "5d9660b559b3f670f4539abb8db0b7c5ee86f90e5427fcb62c5281222a2efe4f"
    sha256 cellar: :any,                 arm64_ventura: "fbc9b6203dd515710ca7bad86d433375236eb69eff580c6381d1d84ba3caa221"
    sha256 cellar: :any,                 sonoma:        "9c5373f13ed753abe8d5722ed8eaddb61bb67104c5ba1b560a25ead30714d798"
    sha256 cellar: :any,                 ventura:       "fae7c0630abc7477902cea4a5117dd85ca291e1ec01e19104a9a7f81e1b9b31b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e501bf96fd3f388fc8315ad378a52e0666d1ee67f32378315fbc9605a6352148"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08d6fb020192b8071dcb9fd3add3b9a951586cbc7a1689e61d244418f1af7c9a"
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
