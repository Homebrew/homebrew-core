class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/get_file.php?file=source/gmic_4.0.7.tar.gz"
  sha256 "f84b215f40cb00de37bff5ec801103af211679794c3602d39c5430dab76005de"
  license "CECILL-2.1"
  head "https://github.com/GreycLab/gmic.git", branch: "master"

  livecheck do
    url "https://gmic.eu/download.html"
    regex(/Latest\s+stable:.*?href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.t/im)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f81c0f40f8ffc742f5a12dcd17b03d4fafec06feaabdec7378fd8daea8f8ce6f"
    sha256 cellar: :any, arm64_tahoe:       "3baa879c611d4fd5a0b1463b815901b273314fa80e76988e63e4781fe2b0f299"
    sha256 cellar: :any, arm64_sequoia:     "0e0a635f4e860aac27c674bb77ebd087690cfc75874f08dbe449661ae3259426"
    sha256 cellar: :any, arm64_linux:       "5870d54d816e930d8c29a833a103aed2639192db0717366e1e7115c9214d73ae"
    sha256 cellar: :any, x86_64_linux:      "d4d0d07fdc3dc5052c056ba280667848c48610b23c0dd98d581caa49507de4e3"
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
