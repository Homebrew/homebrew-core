class Libgosu < Formula
  desc "2D game development library"
  homepage "https://libgosu.org"
  url "https://github.com/gosu/gosu/archive/v1.4.3.tar.gz"
  sha256 "0dadad26ff3ecbc585ce052c3d89cacc980de62690ee62e30ae8a42b1b78d2d7"
  license "MIT"
  head "https://github.com/gosu/gosu.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b1f1d5e187ea354ced29d4c4a1e6560c42ef5aaf6c1caebd12031b744c2173a5"
    sha256 cellar: :any,                 arm64_big_sur:  "55cf01853c42161fba9d39c45d74777e74e2d9407b37b27322ecc5d415d4d37b"
    sha256 cellar: :any,                 monterey:       "a2b97ae580dc8e4ec18b0150a7c7ae6a44613904925ca32b3f16191a553cd400"
    sha256 cellar: :any,                 big_sur:        "c4ae08fc6393c475499ba2a54b1ad5a4af11df9e82b57711313d6b050f6fe039"
    sha256 cellar: :any,                 catalina:       "85fa79fe1257aa9a1af7d6e4bb0356ebef41c5f7dd89a25dad2dd111a6a8f188"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "441b3f0c9c64f2ec64cad83d7db00ace5d9fce01ea4e08a042f69bf879f6bea7"
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
