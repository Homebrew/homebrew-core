class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_4.0.2.tar.gz"
  sha256 "41a601616e81cd28ee67a8a6aaead8062c8b3530854ae3d96e032a6a8e223887"
  license "CECILL-2.1"
  head "https://github.com/GreycLab/gmic.git", branch: "master"

  livecheck do
    url "https://gmic.eu/download.html"
    regex(/Latest\s+stable:.*?href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.t/im)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7353ac728fd25507c77cd6917478633b9ce00413c635c3d2a7c701d1c8a5f973"
    sha256 cellar: :any, arm64_sequoia: "1814b35385637acebbe9de733a37f5f74ea8f79f0a962d16d279322caf247abd"
    sha256 cellar: :any, arm64_sonoma:  "4d783e4742214f59be4cab42b9d643d5f8c9f66e56b5fb8a3f55a38519fbd1d2"
    sha256 cellar: :any, sonoma:        "1c4eaf6f63a8cfee8176f0dae32b0197e8686747ae585d8653f380494e3a248b"
    sha256 cellar: :any, arm64_linux:   "88993a27e1fcb96551b8e43a25b7acedfd7388c646461fe6c8139de1d3716627"
    sha256 cellar: :any, x86_64_linux:  "1d281b509de1ad5847a558bf5ee3935a9d8592febd7886dd7e3fde1c4c1ec96d"
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
