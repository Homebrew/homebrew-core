class Allegro < Formula
  desc "C/C++ multimedia library for cross-platform game development"
  homepage "https://liballeg.org/"
  url "https://github.com/liballeg/allegro5/releases/download/5.2.8.0/allegro-5.2.8.0.tar.gz"
  sha256 "089fcbfab0543caa282cd61bd364793d0929876e3d2bf629380ae77b014e4aa4"
  license "Zlib"
  revision 1
  head "https://github.com/liballeg/allegro5.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  # Linux bottle removed for GCC 12 migration
  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d837a297e5b7a4b135831b2549a9388250de130fb86201c9c160c1211f1ff773"
    sha256 cellar: :any,                 arm64_big_sur:  "674a59e675e01fb444a806ec712cef6de9d42be7ff07a35811a80bc4259c3bdc"
    sha256 cellar: :any,                 monterey:       "0f8f973ab20f49f58f84d61aa5238c83c46ea7ced40cc426c55efc5a5dbfc4be"
    sha256 cellar: :any,                 big_sur:        "42a27ed5656e9ddb3a4cc8b84e1684063cdd87229c3979f0efad7a5cf30077a3"
    sha256 cellar: :any,                 catalina:       "8e271ed2ef392df9cf6bf0d491be1ec8a303099ffe6634000407869969c2d85c"
  end

  depends_on "cmake" => :build
  depends_on "dumb"
  depends_on "flac"
  depends_on "freetype"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "opusfile"
  depends_on "physfs"
  depends_on "theora"
  depends_on "webp"

  on_linux do
    depends_on "jpeg-turbo"
    depends_on "libpng"
    depends_on "libx11"
    depends_on "libxcursor"
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  fails_with gcc: "5"

  def install
    cmake_args = std_cmake_args + %W[
      -DWANT_DOCS=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"allegro_test.cpp").write <<~EOS
      #include <assert.h>
      #include <allegro5/allegro5.h>

      int main(int n, char** c) {
        if (!al_init()) {
          return 1;
        }
        return 0;
      }
    EOS

    system ENV.cxx, "-I#{include}", "-L#{lib}", "-lallegro", "-lallegro_main",
                    "-o", "allegro_test", "allegro_test.cpp"
    system "./allegro_test"
  end
end
