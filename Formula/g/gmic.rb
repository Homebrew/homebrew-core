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
    sha256 cellar: :any,                 arm64_sonoma:   "bc1544c0477c2ff9650ab2d9edc331d903964a5cd67220e418fa224ace593c4b"
    sha256 cellar: :any,                 arm64_ventura:  "a9a4396de37ae1cd09ca6ad3a556db1de11196f7db8973a0a6673062dfa3b49a"
    sha256 cellar: :any,                 arm64_monterey: "87b4dea960e0c75db00122c07dd9961ae37fe96f54ccd73e1d7e818255624201"
    sha256 cellar: :any,                 sonoma:         "e952054cdd2911676f0bd96e9b8b575cc8a48df22f42ae8b0973d8a421ff7f53"
    sha256 cellar: :any,                 ventura:        "42c7a71152831f76aecbed7877796575077b101a85d48324a31de208eb39f743"
    sha256 cellar: :any,                 monterey:       "88b1083843201c1f3e13c8dba094562ab59a2920ab70ad35c64fedeb321928a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3777e122bd44e120c96b1302a2fce51ed2ca52cd75b00277e66af45d1858786"
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
