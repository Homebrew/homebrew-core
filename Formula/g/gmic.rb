class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/get_file.php?file=source/gmic_4.0.8.tar.gz"
  sha256 "de30b742c2c69526732ace3a413d4e81fc08d9cf770c3a7b197298b6ab830b0f"
  license "CECILL-2.1"
  head "https://github.com/GreycLab/gmic.git", branch: "master"

  livecheck do
    url "https://gmic.eu/download.html"
    regex(/Latest\s+stable:.*?href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.t/im)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3ba285b88eb4eff4399a73e6251bface8e5dc126d10ed9f7ee5d1fbee77eab93"
    sha256 cellar: :any, arm64_tahoe:       "e8e11b0f15b99738e6fa1ab258e8fd72b693957017a9a895201675d5517fcc42"
    sha256 cellar: :any, arm64_sequoia:     "a1fe7af09cf9e1bc7a5cab5fd5dcd5d41a5a639469268530c74cae1c89447a95"
    sha256 cellar: :any, arm64_linux:       "33ddf00e1f7764e75eb9a6260cebb6bd29c931341afcaf4e068b9d5f0cb06c6a"
    sha256 cellar: :any, x86_64_linux:      "9694d90d31f3ec8b330e8de4a42621577a7709f0df4750ce89bf06345da05a27"
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
