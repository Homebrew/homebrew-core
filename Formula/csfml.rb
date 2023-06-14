class Csfml < Formula
  # Don't update CSFML until there's a corresponding SFML release
  desc "SMFL bindings for C"
  homepage "https://www.sfml-dev.org/"
  url "https://github.com/SFML/CSFML/archive/2.5.2.tar.gz"
  sha256 "2671f1cd2a4e54e86f7483c4683132466c01a6ca90fa010bc4964a8820c36f06"
  license "Zlib"
  head "https://github.com/SFML/CSFML.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "405f5c73f97dab9728f3fd2d30b8c09ee719cc103b6cd824bd6abcee950dc171"
    sha256 cellar: :any,                 arm64_monterey: "9a05d663003abb8405850793d3894b3b9d57cc19c72937a97926fde63820cf10"
    sha256 cellar: :any,                 arm64_big_sur:  "16615a5ca01e664fe1b43064a098ecb9bee80ee4f04435b74aa4bc0ceb42a60f"
    sha256 cellar: :any,                 ventura:        "c9936c9d1ffa653e22e02f81edfa08d08780f36cf768823d50760492b6e12fce"
    sha256 cellar: :any,                 monterey:       "a4e01b96aa6a3eb3ef492cfe560f1816cca2b04275e7bb06924f3b0cc1c90973"
    sha256 cellar: :any,                 big_sur:        "01153456025704d35a306a890a685cb40750cd81804ba4f304c7718addf049a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2816dc23c34b54f2a3a0d43ec83a9db9a7ec537ddbc45ac5e5e4bd4db16d95ff"
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
