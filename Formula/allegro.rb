class Allegro < Formula
  desc "C/C++ multimedia library for cross-platform game development"
  homepage "http://liballeg.org/"
  url "http://download.gna.org/allegro/allegro/5.2.1.1/allegro-5.2.1.1.tar.gz"
  sha256 "b5d9df303bc6d72d54260c24505889acd995049b75463b46344e797a58a44a71"
  head "https://github.com/liballeg/allegro5.git", :branch => "master"

  bottle do
    cellar :any
    sha256 "8704382be7339cd88ec6ee60e5a0a6dded83d826ff108a480e604cc26e897bf0" => :el_capitan
    sha256 "81b98741d18a30b97264c8adea26a7433f6714db0ed7b38d94340de9c8a50d3b" => :yosemite
    sha256 "49eb9c8a53b50b1c0348221fdf036f96e89f22a85ce02b7ef632d822c98fed67" => :mavericks
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
