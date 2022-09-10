class Allegro < Formula
  desc "C/C++ multimedia library for cross-platform game development"
  homepage "https://liballeg.org/"
  url "https://github.com/liballeg/allegro5/releases/download/5.2.8.0/allegro-5.2.8.0.tar.gz"
  sha256 "089fcbfab0543caa282cd61bd364793d0929876e3d2bf629380ae77b014e4aa4"
  license "Zlib"
  revision 2
  head "https://github.com/liballeg/allegro5.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "13e874b0d1272b8ad700a4c809809c9d521bf54f95076177bf9cbbcb83f07596"
    sha256 cellar: :any,                 arm64_big_sur:  "73585cdf21df62394d4a3c72858aae76663666c39a00100af974f47dac3fd450"
    sha256 cellar: :any,                 monterey:       "2d5ef773c833b823d825cc71f9160104cb079d3a30d786733b3acffa7f4e5c09"
    sha256 cellar: :any,                 big_sur:        "2469c661563807f8221c0fd38d5cc0485afd6d607bbe2c01bc83e9687c96406c"
    sha256 cellar: :any,                 catalina:       "da24f757dd6d378c0fa067c988544a6bd18027c25c9eab8d19ba67f40fe893a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51ecc506faac7fb954ce6654a3d31f976039f6a57157f8e9a93e7c91518d85ca"
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

    system ENV.cxx, "allegro_test.cpp", "-I#{include}", "-L#{lib}",
                    "-lallegro", "-lallegro_main", "-o", "allegro_test"
    system "./allegro_test"
  end
end
