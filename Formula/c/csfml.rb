class Csfml < Formula
  # Don't update CSFML until there's a corresponding SFML release
  desc "SMFL bindings for C"
  homepage "https://www.sfml-dev.org/"
  url "https://github.com/SFML/CSFML/archive/refs/tags/2.6.0.tar.gz"
  sha256 "fee2c40c218cd291e4f4086522bf3b690f750c9b4be10fb67f42d1973a92bca0"
  license "Zlib"
  head "https://github.com/SFML/CSFML.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "abd199c3601d38b1a400457c69c6f0abad215be865bad9fe0b18af2871277fa0"
    sha256 cellar: :any,                 arm64_ventura:  "93edd427c5c7b9e134712b0b26098f115b7d6c1a38b111730e01bea8a1c7fee7"
    sha256 cellar: :any,                 arm64_monterey: "bc9651bc5a2ae540e9e1dee3dddd852d01ad8dba30fa5b9440843c6ee89b4674"
    sha256 cellar: :any,                 sonoma:         "1cd935d96e93751987e2046349ade2a4a209d39f1a4b1b158a3604a9b28a4f74"
    sha256 cellar: :any,                 ventura:        "ff7d7b53678a6a3780e0d4b2892f43e7dcc68339e513c34cf3350d14fc3fd0f3"
    sha256 cellar: :any,                 monterey:       "e3800b0f0a0671fe40fa6bb82f336915ab225a04d3bb0baa2895b8d5494697d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1469dc07b0e988eed340b4f715db767c530dcab5fc02b656ad93f208fd9ca5f7"
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
