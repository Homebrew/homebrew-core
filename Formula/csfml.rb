class Csfml < Formula
  # Don't update CSFML until there's a corresponding SFML release
  desc "SMFL bindings for C"
  homepage "https://www.sfml-dev.org/"
  url "https://github.com/SFML/CSFML/archive/2.5.1.tar.gz"
  sha256 "0c6693805b700c53552565149405a041a00dbe898c2efb828e91999ab8b6b1d4"
  license "Zlib"
  head "https://github.com/SFML/CSFML.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "a8c50f1c117a704b3630dbf4047980de47bf2de5a5a865ff9d2b011028703b67"
    sha256 cellar: :any, arm64_big_sur:  "d2021fddf559448c443461ccfab70aaeb69c6067599404bb181dc1b979c0c0ea"
    sha256 cellar: :any, monterey:       "d172f3a39ed849b71f48c785ee74df265115579aa4204aef2b489af3c772a36b"
    sha256 cellar: :any, big_sur:        "b8c7efa950d02d216b9c734c50b884b79e14812e738bd8a48d2113416677bd7a"
    sha256 cellar: :any, catalina:       "4f7c022c4b4beeffd13e02b31b3feeea3cdef0e4a66a81c7630024d055b398ef"
    sha256 cellar: :any, mojave:         "9ca41ce96eff95ff1cf5bfceebde99b720f8b8a2aaef098eb99a099393991915"
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
