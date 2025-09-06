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
    sha256 cellar: :any,                 arm64_sequoia: "8f2dde990f71c76b2fed198f8b62983b5fa35ea5490e4cc7927ba65e9f3aaf59"
    sha256 cellar: :any,                 arm64_sonoma:  "5edac414b295ead19b6a7987a821ea11ec403760c553c2dc7f80f6de4eab8770"
    sha256 cellar: :any,                 arm64_ventura: "c4eeb3db6765081698662e62d5e86cbc15bb2ddd33783e8533c40a17de004a04"
    sha256 cellar: :any,                 sonoma:        "203beebd6275029a7a94b7d29e491a9c59dcced5e757d8457307399bfc140004"
    sha256 cellar: :any,                 ventura:       "4b5f88aeeec7c513120cc1e3540f45300b98d3409219b0233a70194aec0db733"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a988aa7e914a0caea8619174e90da28da969ae89110f1f5a4b9a1abba37c3d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccfc5ab0c1557ee49aa134fac8fb518904637a61315011ee5b7b82d7b6c10e3b"
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
