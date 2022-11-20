class Libgosu < Formula
  desc "2D game development library"
  homepage "https://libgosu.org"
  url "https://github.com/gosu/gosu/archive/v1.4.3.tar.gz"
  sha256 "0dadad26ff3ecbc585ce052c3d89cacc980de62690ee62e30ae8a42b1b78d2d7"
  license "MIT"
  head "https://github.com/gosu/gosu.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "508771c36effc2738ecdded667c4e619bee5458220d5a98b676691e821932f73"
    sha256 cellar: :any,                 arm64_monterey: "0e9b77d18d40451f7740850fd3fd3b35675756290104d130654929269b21ef46"
    sha256 cellar: :any,                 arm64_big_sur:  "0a5880aa0eb8195d24721fe6efc2f5142ed3828bef09382d36747df83f17551f"
    sha256 cellar: :any,                 ventura:        "19047ae0629feef6311e5df8e9a4fe4e78002e8ed607e051f009f157472fb82c"
    sha256 cellar: :any,                 monterey:       "1924bed9590b5f4ca88336dc96c6064e539a1092d19cd0f81a85af0992dcfe4e"
    sha256 cellar: :any,                 big_sur:        "4bd30ae8c5ae6bee66bdc2a53e83f6bc04e28025698dc7e9011659d9b8966bc3"
    sha256 cellar: :any,                 catalina:       "c1f867cc2d5c2c1e1687f818dff3db86bcc112a87e7f81e811f60f326a8b038a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a8227164000fa5765fedde68a57e40f3b353c6db7404fcde07edfdd1f4fb7b3"
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
