class Allegro < Formula
  desc "C/C++ multimedia library for cross-platform game development"
  homepage "http://liballeg.org/"
  url "https://github.com/liballeg/allegro5/releases/download/5.2.3.0/allegro-5.2.3.0.tar.gz"
  sha256 "5a4d40601899492b697ad5cfdf11d8265fe554036a2c912c86a6e6d23001f905"

  head "https://github.com/liballeg/allegro5.git", :branch => "master"

  bottle do
    cellar :any
    sha256 "35a544646e7e4d38a77afa7032c67506f40cd93447de255d81b1879fa8956c9e" => :high_sierra
    sha256 "ca4daf0ada1bf65e4a0a8cfa6afcde4805fb4921199393f1ca37bd20bdfe4af0" => :sierra
    sha256 "687ea283ee293728c40889db1589844ad4e56acd53ae7fd7238e67e4eea79a0e" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "flac"
  depends_on "freetype"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "opusfile"
  depends_on "physfs"
  depends_on "theora"
  depends_on "webp"
  depends_on "dumb" => :optional

  def install
    args = std_cmake_args
    args << "-DWANT_DOCS=OFF"
    args << "-DWANT_MODAUDIO=1" if build.with?("dumb")
    mkdir "build" do
      system "cmake", "..", *args
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

    system ENV.cxx, "-I#{include}", "-L#{lib}", "-lallegro", "-lallegro_main", "-o", "allegro_test", "allegro_test.cpp"
    system "./allegro_test"
  end
end
