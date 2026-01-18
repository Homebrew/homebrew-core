class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_3.6.6.tar.gz"
  sha256 "f93d725d8fd98122483704ec07928c3275a4b9149e81328f4b07e7d6ceb4c919"
  license "CECILL-2.1"
  head "https://github.com/GreycLab/gmic.git", branch: "master"

  livecheck do
    url "https://gmic.eu/download.html"
    regex(/Latest\s+stable:.*?href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.t/im)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a1dde8e1b0a63ff2eadf598a985a40abfa8bd324eccbbf4094703867145a502c"
    sha256 cellar: :any,                 arm64_sequoia: "a41210137047a7c047154ae24ffcc4cd3f323f2ec3a9d40d941784b0823d628c"
    sha256 cellar: :any,                 arm64_sonoma:  "d649edc3cde2add8d636504f72474790e53a4d6e2387b1f766f886b47cd7d560"
    sha256 cellar: :any,                 sonoma:        "729e8385b33404e551ff09e5f371c1d48806b3df09e1252fa059824c4b675b57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fdb61b8ff49df8be2e5411156eebac5941968d2f59562ceb80dd8e071e2caa35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aecaca62ce6c15c46a6a2939204c79a9d438161687f80bc0e22bda595616a68f"
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
