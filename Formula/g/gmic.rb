class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_4.0.5.tar.gz"
  sha256 "c6771c48693ed615b2e85d1db7a9626358d4606eb2c75dcf009b2924f396da59"
  license "CECILL-2.1"
  head "https://github.com/GreycLab/gmic.git", branch: "master"

  livecheck do
    url "https://gmic.eu/download.html"
    regex(/Latest\s+stable:.*?href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.t/im)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ff5e0846f7e56974765a1024da244a8fb2fd69abb69e536425b18dc6f22a9ac2"
    sha256 cellar: :any, arm64_sequoia: "3213641b846514fbd28d46eb3f3a8eff179089a29eab78d4f3bff742c100ca65"
    sha256 cellar: :any, arm64_sonoma:  "912d93075511e67ea756e0eaf2f8cf46f40476758c0384ec9bb41fc2387f462d"
    sha256 cellar: :any, arm64_linux:   "f530c7ddb913ee3f988a3ec83cb346740ddd072f06f9bd0825b4e752468fba30"
    sha256 cellar: :any, x86_64_linux:  "4d295bd6a34d698e66b10d713bfbde59104907c81239083b3d6294d7daf8fb91"
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
    args = %W[
      -DCMAKE_EXE_LINKER_FLAGS=-Wl,-rpath,#{rpath}
      -DENABLE_DYNAMIC_LINKING=ON
      -DENABLE_FFMPEG=OFF
      -DENABLE_GRAPHICSMAGICK=OFF
      -DUSE_SYSTEM_CIMG=ON
    ]
    args << "-DENABLE_X=OFF" if OS.mac?

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
