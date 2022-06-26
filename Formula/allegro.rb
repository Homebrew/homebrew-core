class Allegro < Formula
  desc "C/C++ multimedia library for cross-platform game development"
  homepage "https://liballeg.org/"
  url "https://github.com/liballeg/allegro5/releases/download/5.2.8.0/allegro-5.2.8.0.tar.gz"
  sha256 "089fcbfab0543caa282cd61bd364793d0929876e3d2bf629380ae77b014e4aa4"
  license "Zlib"
  head "https://github.com/liballeg/allegro5.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "943c0bcffe61c4ac162a9c366801be695deb82028416b735ba62159df24d9ec9"
    sha256 cellar: :any,                 arm64_big_sur:  "b1ef1fcf152a1811ce51ead541c3a29dd1b29999c77dfad92e431360a9d5fee2"
    sha256 cellar: :any,                 monterey:       "a4bec0f69c3cdf94e838505d5daad20853e0be88ba3c4aa2b46952f64c62e4a9"
    sha256 cellar: :any,                 big_sur:        "becf765b1d4061243aa4f72dcfc0ca8c06c3ef625f2e775824f9a63fe83822d1"
    sha256 cellar: :any,                 catalina:       "e026e88044ae9d37c663f31aad61fd6f3bb3350298715200fb728769ef542b63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05302ddcc81c5eb504846cbef286537436e20835e4d957eb3b64b3db52b05be9"
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
    depends_on "gcc"
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
