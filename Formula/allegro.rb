class Allegro < Formula
  desc "C/C++ multimedia library for cross-platform game development"
  homepage "http://liballeg.org/"
  url "http://download.gna.org/allegro/allegro/5.2.1.1/allegro-5.2.1.1.tar.gz"
  sha256 "b5d9df303bc6d72d54260c24505889acd995049b75463b46344e797a58a44a71"
  head "https://github.com/liballeg/allegro5.git", :branch => "master"

  bottle do
    cellar :any
    sha256 "73bd8ce63b7d8788973abc736e27bb342dd03c7e9d33be241ae9847d483ee448" => :el_capitan
    sha256 "00aaa7f60e21646bf62365e4f33b7bba1a24c4386a5410317e0a9b8452b4ac1b" => :yosemite
    sha256 "eac2ca128fca38ab9b5636808a927ce4941859312592acc1b6b10dd7f8f88af3" => :mavericks
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
