class Allegro < Formula
  desc "C/C++ multimedia library for cross-platform game development"
  homepage "http://liballeg.org/"
  url "https://github.com/liballeg/allegro5/releases/download/5.2.2.0/allegro-5.2.2.tar.gz"
  sha256 "e285b9e12a7b33488c0e7e139326903b9df10e8fa9adbfcfe2e1105b69ce94fc"

  head "https://github.com/liballeg/allegro5.git", :branch => "master"

  bottle do
    cellar :any
    sha256 "f1bcce974ffeeedb441e364fdc4a3fdc7eb34a0f051f612534a408baf206cf5c" => :sierra
    sha256 "50894c87f68741f5f65e148a31662cf5a7feead3072884352b77a4e0be8860fa" => :el_capitan
    sha256 "f87c93bceed439a7cd581ee6d305b30268d113cd1f76205c5f32651acde370a6" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "flac"
  depends_on "freetype"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "opusfile"
  depends_on "physfs"
  depends_on "theora"
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
    (testpath/"allegro_test.cpp").write <<-EOS
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
