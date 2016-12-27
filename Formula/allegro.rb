class Allegro < Formula
  desc "C/C++ multimedia library for cross-platform game development"
  homepage "http://liballeg.org/"
  url "http://download.gna.org/allegro/allegro/5.2.2/allegro-5.2.2.tar.gz"
  sha256 "e285b9e12a7b33488c0e7e139326903b9df10e8fa9adbfcfe2e1105b69ce94fc"

  head "https://github.com/liballeg/allegro5.git", :branch => "master"

  bottle do
    cellar :any
    sha256 "8491d79cf614dbf5a4fe3798d18d70493c64035d8d9c36db580f3654b7d294fe" => :sierra
    sha256 "91486ac3298f48f4160fbed4980fc0ee3f92ff9ee6c3d92b9d1af83fc5bb2c88" => :el_capitan
    sha256 "7488de3a760d2e36ab3a5933cff118c622a3dd9fb854bc31b8934922bb5cede6" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "libvorbis" => :recommended
  depends_on "freetype" => :recommended
  depends_on "flac" => :recommended
  depends_on "physfs" => :recommended
  depends_on "libogg" => :recommended
  depends_on "opusfile" => :recommended
  depends_on "theora" => :recommended
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
