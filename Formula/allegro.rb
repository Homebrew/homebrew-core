class Allegro < Formula
  desc "C/C++ multimedia library for cross-platform game development"
  homepage "https://liballeg.org/"
  url "https://github.com/liballeg/allegro5/releases/download/5.2.6.0/allegro-5.2.6.0.tar.gz"
  sha256 "5de8189ec051e1865f359654f86ec68e2a12a94edd00ad06d1106caa5ff27763"
  license "Zlib"
  head "https://github.com/liballeg/allegro5.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "fccd4a2c8eda6101d7a7f0dffe598cdafc4594b8fc247548d48d6eafe85e0cc3" => :big_sur
    sha256 "709d62d7f2191f409671467cf25ec25edcb97641729277a62cc6cca065db4b0e" => :arm64_big_sur
    sha256 "9e71511f6c8faa8449dd06bc30bd74497ee832e3e0ca7f3eb02bcef263ab4b3f" => :catalina
    sha256 "ead9f69a2af4720ad8a9e020657b1db71e49cb3e83d9d8477d425de9d948ce07" => :mojave
    sha256 "4ab4367b267e257a1aeee6cd65301922cf38cb37e8c11865edecedac5960f96e" => :high_sierra
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

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DWANT_DOCS=OFF"
      system "make", "install"
    end
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
