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
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "bd1673487779c1a94ed846b5daeb57b2acecbc7f404fae4cdd6d15c66fb357e4"
    sha256 cellar: :any, arm64_tahoe:       "a3c00ae7d0cab177418e689783cef4ea3c90652924bc283b54e2408ffeb2e4ee"
    sha256 cellar: :any, arm64_sequoia:     "31f6732769d29af9490456eb8c04261c8354cf843f13035e8155d4023673ba7a"
    sha256 cellar: :any, arm64_linux:       "666458ad5c98aa243ab59c4c2e766410188a3b911563283fb332fa564272e248"
    sha256 cellar: :any, x86_64_linux:      "b0784e361b837561db7ca0969a215f83246cef17e9976d4112e21b018ca55890"
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
