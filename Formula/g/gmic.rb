class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_4.0.3.tar.gz"
  sha256 "40384654ac667c8c5d86543a1b6bf6d239fb9788d76ad671325e63ac36a5f82b"
  license "CECILL-2.1"
  head "https://github.com/GreycLab/gmic.git", branch: "master"

  livecheck do
    url "https://gmic.eu/download.html"
    regex(/Latest\s+stable:.*?href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.t/im)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e9143312e0af64e5d04bc7644c6ad16a6d2629f4a6de71e00ed209bc8242affb"
    sha256 cellar: :any, arm64_sequoia: "a2c8f7325d1683a856eaddce29e375e00e2a248f226ee1bb0f38b760c9b11651"
    sha256 cellar: :any, arm64_sonoma:  "20e1fe7db07a0efffe9f063a366100016bd4369de5a905633e04e89b9fe7b39b"
    sha256 cellar: :any, sonoma:        "89c1d43390d28c9e5749c096053d8259456ff5f97df4375b41db8f94d38be3f1"
    sha256 cellar: :any, arm64_linux:   "a38c678502276772caa5ac3021f1108c0db6735ad27e217f9ee232da34b2c98c"
    sha256 cellar: :any, x86_64_linux:  "edd7f15e29f3f93f0e293bedac1a08dfe6970407849054eea48c030a26389418"
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
