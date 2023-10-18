class Csfml < Formula
  # Don't update CSFML until there's a corresponding SFML release
  desc "SMFL bindings for C"
  homepage "https://www.sfml-dev.org/"
  url "https://github.com/SFML/CSFML/archive/2.5.2.tar.gz"
  sha256 "2671f1cd2a4e54e86f7483c4683132466c01a6ca90fa010bc4964a8820c36f06"
  license "Zlib"
  revision 1
  head "https://github.com/SFML/CSFML.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9faf9aff5b2bd8f901055d477e3ff0702fa675ccb6dea5fc1f34f79ce50acd38"
    sha256 cellar: :any,                 arm64_ventura:  "ffe6c174f1386b9aa9e82eebf34240395dec2167a8783861cb10fd9f64654275"
    sha256 cellar: :any,                 arm64_monterey: "4d40b9e48454350f58bac875b12091e58de655677abc212eb32808fa97536fe2"
    sha256 cellar: :any,                 arm64_big_sur:  "caa271cb7428aa9813fada7fe4d080faa058f3b1599c2ef4eff05453260658a3"
    sha256 cellar: :any,                 sonoma:         "0ed8a2f8ae71c6813fff337242e774b45d2d141500ca18687ee1432ad2661008"
    sha256 cellar: :any,                 ventura:        "dd3a2adba0082f3d5505d1564345bd28ccfa2a4eaf00642558354e025140a7c0"
    sha256 cellar: :any,                 monterey:       "881ff68b8f8a5e2f9e4feac22d1af3f7255179bd0cac00720e358059a717be5f"
    sha256 cellar: :any,                 big_sur:        "37b4d2ae7b2f5ff1a9032b8086eaa7b0d3960185f264f28992d053621feb094a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33bc409017a399d20809d94e7280864a48125da44205a2a64ed9de6e0298b971"
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
