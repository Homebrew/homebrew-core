class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_3.5.2.tar.gz"
  sha256 "5893b6e87a52792e12af2b51121465d6202a2310c2a751c5c9785910ff55dc14"
  license "CECILL-2.1"
  head "https://github.com/GreycLab/gmic.git", branch: "master"

  livecheck do
    url "https://gmic.eu/download.html"
    regex(/Latest\s+stable:.*?href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.t/im)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ded29ccfc52a336135f9ec8ace1867d50ef2da65dfc7296a41aa133468432327"
    sha256 cellar: :any,                 arm64_sonoma:  "7df9faff141bdd69da0ec26cc90ce2f63d18a267375ff160a15e64629f52e6f9"
    sha256 cellar: :any,                 arm64_ventura: "95ff0cda2aa356d38b5fb008b84ed5bcfc614c004d82a0c95662830c58437ab6"
    sha256 cellar: :any,                 sonoma:        "d896f0591e9dd722a52636177e9ef5113ae0e3f9837f83abbfe449d33b087ba9"
    sha256 cellar: :any,                 ventura:       "88fc0794b47aa7ddbfab7ad75dcb5a4f6c6631f61502a35917a50c9502289cf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38e37d9c0aceef9a61113171ba3541591ed88cbc3db25a87e4fe55270457c6cf"
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
