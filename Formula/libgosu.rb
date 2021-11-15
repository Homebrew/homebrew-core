class Libgosu < Formula
  desc "2D game development library"
  homepage "https://libgosu.org"
  url "https://github.com/gosu/gosu/archive/v1.2.0.tar.gz"
  sha256 "89e3d175c7a7c27ae9722a719e7307a77aefac0d28c9c9e2b531ca84e080aab6"
  license "MIT"
  head "https://github.com/gosu/gosu.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "177e0764d488b1fc2c65930a8a6517241abc0c874c039fa7123aa174866e355a"
    sha256 cellar: :any,                 arm64_big_sur:  "2fdd60050495a39676631ff20b6adce12f08509dfafc07d5544922d6bbc07ea2"
    sha256 cellar: :any,                 monterey:       "e24ea7efd2ad3863304dfcd2aba1505490b781457f9b3e30e60c9b0d019f23db"
    sha256 cellar: :any,                 big_sur:        "81fcf49b8dcd3c32e765c1c160fde1587fd7fc72dc69a02e0369a2f6933b2c7d"
    sha256 cellar: :any,                 catalina:       "260af0d8a2ec9e279c80748fab5824583bf452c92ae1fd2ad974effc7e79c946"
    sha256 cellar: :any,                 mojave:         "681e8df033559e1f7af28bd4d9da638be31e56261ddaca28338f6a2a91cfc569"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07df8bc6b2dbf05c618bcb323dd32b59762faa0ca996d238fcc15a0ed2ddad4d"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sdl2"

  on_linux do
    depends_on "fontconfig"
    depends_on "gcc"
    depends_on "mesa"
    depends_on "mesa-glu"
    depends_on "openal-soft"
  end

  fails_with gcc: "5"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
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
              set_caption(\"Hello World!\");
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

    on_linux do
      # Fails in Linux CI with "Could not initialize SDL Video: No available video device"
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]
    end

    system "./test"
  end
end
