class Csfml < Formula
  # Don't update CSFML until there's a corresponding SFML release
  desc "SMFL bindings for C"
  homepage "https://www.sfml-dev.org/"
  url "https://github.com/SFML/CSFML/archive/2.5.1.tar.gz"
  sha256 "0c6693805b700c53552565149405a041a00dbe898c2efb828e91999ab8b6b1d4"
  license "Zlib"
  head "https://github.com/SFML/CSFML.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "0b5c92332e9fc998f9c548de0706f4d7bc230b582691789c19830ee44fd0bfa2"
    sha256 cellar: :any,                 arm64_monterey: "c4fea6bf57896674c9c9abe693aa48edc8fb265607acbb6eb296d7c9bb75937f"
    sha256 cellar: :any,                 arm64_big_sur:  "5da07203f213b3cd0f89cf61d454ee5fdcc0579fa033185b5b7bb4d28265c867"
    sha256 cellar: :any,                 ventura:        "dede71e2be0599798a98e6887ae7a729d9c79e393dc516c4411fcea2e7458402"
    sha256 cellar: :any,                 monterey:       "0e28a1870c7025c51e561274a2623e259813fb0754fd81406d379e3bbd31b360"
    sha256 cellar: :any,                 big_sur:        "0b05f5e20a8a84a0343da2ef5a0ac7ea33cc45359b57fb15d5265ec019baf048"
    sha256 cellar: :any,                 catalina:       "b77291facbded3e67f15271030cd251fd3f59e6a79f6ac4012ae55f77e8e2032"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb64c718f75186bd5df094255eaedf3ace73edc718b1505a1a031551e8c5a37a"
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
    # Disable this part of the test on Linux because display is not available.
    system "./test" if OS.mac?
  end
end
