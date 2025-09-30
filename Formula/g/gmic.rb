class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_3.6.2.tar.gz"
  sha256 "e85161d5eaf6eb413c2db6bc397c487617cea7916f21bce7a3b6acfa001fbf46"
  license "CECILL-2.1"
  head "https://github.com/GreycLab/gmic.git", branch: "master"

  livecheck do
    url "https://gmic.eu/download.html"
    regex(/Latest\s+stable:.*?href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.t/im)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "531f8f66cd6491bbb3c3c68af818a176a4c93136b7d53fa12fbcfe898798d1f9"
    sha256 cellar: :any,                 arm64_sequoia: "00f2e4b770e01e548d67c0a2470e664f47145d4510fa5cc9889c1dcc582a3c8d"
    sha256 cellar: :any,                 arm64_sonoma:  "3cbff392e0c5ea0c813b1235871e9c09a17f3841d4958caf9ec1037addf41a22"
    sha256 cellar: :any,                 sonoma:        "64ddd280f2c6442aa922c9cf04dd9c95fc6b666a9f1b58dd06d37c7e4a28ed83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "840e278d8b95b5cc9d30abdf59a4a0c97a523e27350d819726c9bbf0453b775e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f8392f8582c52e0eb0703a3f334e10e17078866cd6b581ea611cd73db3a8867"
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
