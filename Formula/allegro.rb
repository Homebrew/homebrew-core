class Allegro < Formula
  desc "C/C++ multimedia library for cross-platform game development"
  homepage "http://liballeg.org/"
  revision 1

  head "https://github.com/liballeg/allegro5.git", :branch => "master"

  stable do
    url "http://download.gna.org/allegro/allegro/5.2.1.1/allegro-5.2.1.1.tar.gz"
    sha256 "b5d9df303bc6d72d54260c24505889acd995049b75463b46344e797a58a44a71"

    # Fix compilation on 10.12
    # https://github.com/liballeg/allegro5/pull/682
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/2daef1c/allegro/patch-allegro-10.12.diff"
      sha256 "f2879676a370749319b8247ab7437b8060c9d9dc2f58f45db0d782419fe37adf"
    end
  end

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
