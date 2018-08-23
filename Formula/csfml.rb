class Csfml < Formula
  # Don't update CSFML until there's a corresponding SFML release
  desc "SMFL bindings for C"
  homepage "https://www.sfml-dev.org/"
  url "https://github.com/SFML/CSFML/archive/2.4.tar.gz"
  sha256 "4e3d9a03afafbd3a507c39457a7619b68616ec79e870b975e09665e924f9c4c6"
  head "https://github.com/SFML/CSFML.git"

  bottle do
    cellar :any
    sha256 "47ee888d4a09fcacbf1fbc242455a167bd7e3a8525e26883c22a1b511d04c037" => :mojave
    sha256 "f6507fafb4cbb87b11f6763c5683926b618e0f3795567329669efcff80264ae3" => :high_sierra
    sha256 "9ad1dd48f601df0772a86cbb1101d75b29a89c8ef6269974187cbb4202f21e6a" => :sierra
    sha256 "041543d0017f035714db20025d1b115227780ae5ac10de4ae9a56ad39fade888" => :el_capitan
    sha256 "94edea36f26da5c9e87e2bfb114faa9dd479eb4f2dd7beeab5c00969708954a8" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "sfml"

  def install
    system "cmake", ".", "-DCMAKE_MODULE_PATH=#{Formula["sfml"].share}/SFML/cmake/Modules/", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
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
