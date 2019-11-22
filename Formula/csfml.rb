class Csfml < Formula
  # Don't update CSFML until there's a corresponding SFML release
  desc "SMFL bindings for C"
  homepage "https://www.sfml-dev.org/"
  url "https://github.com/SFML/CSFML/archive/2.5.tar.gz"
  sha256 "d49ddfbe9c14dbca60dd524d10bca7922142dc32a07a5dfbbd209cda7caad860"
  head "https://github.com/SFML/CSFML.git"

  bottle do
    cellar :any
    sha256 "31fd66bf0d673c538efda5d66495bee9c4dddbf0c037d8066484c062dd3aaa3d" => :catalina
    sha256 "23ba78c253971cd63e84eb54763fac657beafa93f445ee851ba90c8e80146bbb" => :mojave
    sha256 "4c5a98b1bd072adaacae84e7ab0f3c7f33b74c72378f303e3f35fae6dabd4df4" => :high_sierra
    sha256 "acfb319f9d70db51adf39a6931dfc938871ce9f9ad6dcb43d8395c7d735a2674" => :sierra
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
