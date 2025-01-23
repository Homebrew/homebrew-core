class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_3.5.0.tar.gz"
  sha256 "847ddf438bbe73ec1447a8d98916571c75664bed050ac11212e45b2eb4c1cad0"
  license "CECILL-2.1"
  head "https://github.com/GreycLab/gmic.git", branch: "master"

  livecheck do
    url "https://gmic.eu/download.html"
    regex(/Latest\s+stable:.*?href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.t/im)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "af7758f64e8dc5dafbea4afd4562506a0345cae23cf3826d44dee8d1a5d15ec0"
    sha256 cellar: :any,                 arm64_sonoma:  "358dcfe6133017dec8dd73aeeff0739f3a6851e1b6a1b04e5799b4e1ddf4be23"
    sha256 cellar: :any,                 arm64_ventura: "b53df6080acd6b4a5fc812af57eb78a9370fa7e48579a207fc52685af76ddace"
    sha256 cellar: :any,                 sonoma:        "918a9e49aaa9f7aa4f8f4dd8f7fcb64b0a982f76839017b36b417b208abf73fd"
    sha256 cellar: :any,                 ventura:       "eee8261136f04545d64ddd679d4ec2338f19896e32e3374dd2e3b99251ab574a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0c3f3483b3abd4fdf4a67fae670777316344648dd6c07208dfcf4a98dabf3be"
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
