class Csfml < Formula
  # Don't update CSFML until there's a corresponding SFML release
  desc "SMFL bindings for C"
  homepage "https://www.sfml-dev.org/"
  url "https://github.com/SFML/CSFML/archive/refs/tags/2.6.1.tar.gz"
  sha256 "f3f3980f6b5cad85b40e3130c10a2ffaaa9e36de5f756afd4aacaed98a7a9b7b"
  license "Zlib"
  head "https://github.com/SFML/CSFML.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "02e7a77b215a808cd2948b295752ea660f0a9ce2065c4ebae68ff20dbfcf6364"
    sha256 cellar: :any,                 arm64_sonoma:   "51106a18de295924740040dfe451298bf81642b99085741ab536200be362a270"
    sha256 cellar: :any,                 arm64_ventura:  "49eef8514705e01c7bdaf6fb3c82aacee098eb42bcdbc671a937e100e51dec23"
    sha256 cellar: :any,                 arm64_monterey: "99aa119e5df305ad65af18397978c39e2f2ea88c3aaafbd9e4c62fb92a5e24b0"
    sha256 cellar: :any,                 sonoma:         "41a00b5ee1f4c5210ebbf52210c29738921466d3de8c0144a225b47f1376bd0b"
    sha256 cellar: :any,                 ventura:        "cf5c4fc6532d7ccd3efe857e3f0bbf472bcb105f38dbf9c58a7cbd2e0a77b4a5"
    sha256 cellar: :any,                 monterey:       "517ba2b6d220a8b0a8520959439299feb154edb343fcb7ed2c63842db250ca5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a820796c52b40aeab5cd532d5a4eb51920783e5571c5621824b23d0f452947ea"
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
