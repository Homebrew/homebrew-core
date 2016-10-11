class Csfml < Formula
  # Don't update CSFML until there's a corresponding SFML release
  desc "SMFL bindings for C"
  homepage "http://www.sfml-dev.org/"
  url "https://github.com/SFML/CSFML/archive/2.3.tar.gz"
  sha256 "ba8f5529fd264c2778844a8b1bb71ede7e902bbd6841275c344dc488ce7054cd"
  revision 1

  head "https://github.com/SFML/CSFML.git"

  bottle do
    cellar :any
    sha256 "89a50b1ce1bd73ed5039f7739a6872decadead365a2cc44289a1e0a2a223284a" => :sierra
    sha256 "5cbe3b961dac61fc0e7956edbee6ba799c3f8e5511ff1817f38494ff4acccf9d" => :el_capitan
    sha256 "076fff54696922762c7256979fc2c9859348709c155ff110bf41c08b14e87b1b" => :yosemite
    sha256 "b46151808b6ec8439fb8a69dfe35109edd30f6ec5cb0bd89337deddc89c5064d" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "sfml"

  def install
    system "cmake", ".", "-DCMAKE_MODULE_PATH=#{Formula["sfml"].share}/SFML/cmake/Modules/", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <SFML/Window.h>

      int main (void)
      {
        sfWindow * w = sfWindow_create (sfVideoMode_getDesktopMode (), "Test", 0, NULL);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lcsfml-window", "-o", "test"
    system "./test"
  end
end
