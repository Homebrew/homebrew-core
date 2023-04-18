class Libgosu < Formula
  desc "2D game development library"
  homepage "https://libgosu.org"
  url "https://github.com/gosu/gosu/archive/v1.4.5.tar.gz"
  sha256 "051fe5954b14273cf370d94dabad42abe63af95c4f86009b98efd6bf47540c0b"
  license "MIT"
  head "https://github.com/gosu/gosu.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3faddbf628295fbbd1bd4c3efa1ae5c082002695d4592c0394332c201cea1231"
    sha256 cellar: :any,                 arm64_monterey: "9df80df6a55866654a63ba86f19b635ccda5bb3a38f835d0694a8afefa3191e1"
    sha256 cellar: :any,                 arm64_big_sur:  "4d627075f586692786b2c01b589090e1ff47f6b2ce9ced252c5206e22f0d0ca5"
    sha256 cellar: :any,                 ventura:        "1d549d8dcb7546a056935123c8c072ec880044d85617610f66dd7e0ae8635b43"
    sha256 cellar: :any,                 monterey:       "2b4e38af9b2b791731c1e79550f3ad7c45187286ce03582a31afafbcb7900ee4"
    sha256 cellar: :any,                 big_sur:        "2444114e3d70c6d55894a3e98dc308d4be9284942f58af1c75c5e1c2753a8047"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7dc955e8fd596caa0204ee4734a5c3d01bfee7e937d83d26e48ab6099fceaa0"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sdl2"

  on_linux do
    depends_on "fontconfig"
    depends_on "mesa"
    depends_on "mesa-glu"
    depends_on "openal-soft"
  end

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <stdlib.h>
      #include <Gosu/Gosu.hpp>

      class MyWindow : public Gosu::Window
      {
      public:
          MyWindow()
          :   Gosu::Window(640, 480)
          {
              set_caption("Hello World!");
          }

          void update()
          {
              exit(0);
          }
      };

      int main()
      {
          MyWindow window;
          window.show();
      }
    EOS

    system ENV.cxx, "test.cpp", "-o", "test", "-L#{lib}", "-lgosu", "-I#{include}", "-std=c++17"

    # Fails in Linux CI with "Could not initialize SDL Video: No available video device"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "./test"
  end
end
