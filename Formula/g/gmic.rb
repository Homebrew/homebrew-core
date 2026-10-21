class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_4.0.6.tar.gz"
  sha256 "4463f82277f800e81d56f43b82c8736994bd24ac1115320b965b67091d1366df"
  license "CECILL-2.1"
  head "https://github.com/GreycLab/gmic.git", branch: "master"

  livecheck do
    url "https://gmic.eu/download.html"
    regex(/Latest\s+stable:.*?href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.t/im)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7db680998ad70077127dd43e9eedf8caf660e43db101bdea445a79ebf7b9a931"
    sha256 cellar: :any, arm64_tahoe:       "b7dd3d65b608e0e42458376b0b15e2a95488ee57157221f8360a670f665947b9"
    sha256 cellar: :any, arm64_sequoia:     "47e56b2dd05092736bc933a7ffa2dd7bfec12b3565f4fd6240a05391048c781b"
    sha256 cellar: :any, arm64_linux:       "58e68b72a1fc26e959133b2ae97d3a36be78b3b3a3198394fcb62938cf89253f"
    sha256 cellar: :any, x86_64_linux:      "5d84c40bb5f749ecf4cc6f905f0c423466049c871e8197776d30102e97760b78"
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
