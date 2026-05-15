class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_3.7.6.tar.gz"
  sha256 "949cf0e434bc93ab1e6e42c9a0bd5fe39684bba28a910e253048e54d68342656"
  license "CECILL-2.1"
  head "https://github.com/GreycLab/gmic.git", branch: "master"

  livecheck do
    url "https://gmic.eu/download.html"
    regex(/Latest\s+stable:.*?href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.t/im)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e7259b7521688f9f4ac40974fd923bf1e45a42d7f79c1bbbdafe90596aea37e8"
    sha256 cellar: :any,                 arm64_sequoia: "8e9b530020e805a93a2b5322882f502117f525b165d68e39350cf51dc53f7325"
    sha256 cellar: :any,                 arm64_sonoma:  "6086266a2e6b90689138cb0a60c0c8caaeb3ac3de34c491c2ad4dbf80f2caab6"
    sha256 cellar: :any,                 sonoma:        "fe80d760a5c16dc3043d0344ab47ab8632949242452605b0985e7a7ef92f5caa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "487ab7f9bdd2895209eccd3f1eacc472a16a1215953e5c58fadc4cc8f1e2ff88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45b0c3e73877017b73bd08da0af9473b5a493ab502e7caf616121ad5ba8f6932"
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
