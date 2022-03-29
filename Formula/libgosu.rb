class Libgosu < Formula
  desc "2D game development library"
  homepage "https://libgosu.org"
  url "https://github.com/gosu/gosu/archive/v1.4.1.tar.gz"
  sha256 "48c1eec7c9ed11db71358bfc2b3c371d070ce17112b992215a6e267f54176987"
  license "MIT"
  head "https://github.com/gosu/gosu.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "123cd8c6795e69e593c86274fff30d7fb5261369f6fc9771ae11914cb6c66e23"
    sha256 cellar: :any,                 arm64_big_sur:  "fef5d8ff919a520e720ff7b3b7fb7e673efc3ec1d073402979e590f03b1c5ac6"
    sha256 cellar: :any,                 monterey:       "fdf4e91332cad00c9b1dc8cb5779a31e23fb330c052393fdb59c4d29cbfb8ef4"
    sha256 cellar: :any,                 big_sur:        "fd42748a6359d9942eca93db1139c6e967758c5d27cedb6380a1b838f0913c6f"
    sha256 cellar: :any,                 catalina:       "58c348cc0c0f34b88763b78d414b6054723a67e759b9377173a32fd59c584e51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9ca33086397d4162d96272a7e542339e479bec84353ebac20d9d95a1e86650a"
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

    # Fails in Linux CI with "Could not initialize SDL Video: No available video device"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "./test"
  end
end
