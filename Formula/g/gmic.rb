class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_3.5.4.tar.gz"
  sha256 "7e3a1aa75c00603fb01fa2cad686c8d2f1ec81dd820f6688cba3c44dd255aeef"
  license "CECILL-2.1"
  head "https://github.com/GreycLab/gmic.git", branch: "master"

  livecheck do
    url "https://gmic.eu/download.html"
    regex(/Latest\s+stable:.*?href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.t/im)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "84b333f9570730472d532ec4f85692e526f0f52addf291edadc5d2c09575a395"
    sha256 cellar: :any,                 arm64_sonoma:  "3bf3477e06589867923646f81920640e331a4ec8ed11b1a481eab22544de546c"
    sha256 cellar: :any,                 arm64_ventura: "b99fb403e1db7415c31b6b75d6730a64f8db6c254a78a4f25770ed2b46e3d03d"
    sha256 cellar: :any,                 sonoma:        "19b4ca330ad4906ae3b7f37ee73268f0a3d403433f0bbb365c415a70771787b5"
    sha256 cellar: :any,                 ventura:       "40b3f5ef1d38759a54406c034514770669b6e830d042dc78e3c4f6180bb39a79"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "591c26e732a8571cdd3ffca510ef875cc89ba8b5101e048e821abe2bf3e7061e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a0fbd621326b8ed888fabd2e51a5e2fea6c00497dc5128097bd7559f59b6fdf"
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
