class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_3.7.0.tar.gz"
  sha256 "ccb17e22a726b5dbafd1811a519a1a1cf823fb671de600e0d1b1b27bcd4b694d"
  license "CECILL-2.1"
  head "https://github.com/GreycLab/gmic.git", branch: "master"

  livecheck do
    url "https://gmic.eu/download.html"
    regex(/Latest\s+stable:.*?href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.t/im)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3ec26526c62b93dcb7053312ae91e161ed1bbe37a29c4b6c77b8eedc1d08c96e"
    sha256 cellar: :any,                 arm64_sequoia: "cda05a9dac9da0eea85c1a75337f11a7ea479fb49759d7a8f2f164cc3f6151fa"
    sha256 cellar: :any,                 arm64_sonoma:  "c531269d52e887016f45ba330526361f528782f5a018344d7f8a5124aae0dc7d"
    sha256 cellar: :any,                 sonoma:        "4090d0043afff2a2548ba6db412f8b012a1d173bd16972115758c4c9fafad7da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50428953ef8dcef9039ac16b2d860a085b5679d0243d2d5e824897fdd5de6ae5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0054e7907296e629697ae42d5aabe2338e8ce18509d637cb315be62d97893646"
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
