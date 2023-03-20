class Libzim < Formula
  desc "Reference implementation of the ZIM specification"
  homepage "https://github.com/openzim/libzim"
  url "https://download.openzim.org/release/libzim/libzim-8.1.0.tar.xz"
  sha256 "8c9bda942772bb8de1acf4832d4bda5c913d9595506187b62a35ae15e530221f"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "a6d9fe582f379bf28c504fe7e52c066614f9475f6c5cd452a683ae3172901d29"
    sha256 cellar: :any, arm64_monterey: "4be6ea7ed0c02b88773e4e09d621af34f404ec7ec1f722aab4452ebd149ce9eb"
    sha256 cellar: :any, arm64_big_sur:  "e5db7a0353dc07166f84e787492c3214d3c08b0c04cd8cedd876600777ff507a"
    sha256 cellar: :any, ventura:        "96a6baf73906fe9393acd86b99578975b25b6d6c206d4a0951b63d4c313ca75e"
    sha256 cellar: :any, monterey:       "f9ff11e63832ce458c6e9b76f8d453d56c876b8508767bd61a0b1da3847ad994"
    sha256 cellar: :any, big_sur:        "420b1c9b5f262b4ed92ae6185d06bd1798f80c0d608810c9aadcac036ece1004"
    sha256               x86_64_linux:   "7ceb031066301905cd5d5a52b33eacaaa4cbb04be6690ef193aebc73d32d928c"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "icu4c"
  depends_on "xapian"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "python" => :build

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <zim/version.h>
      int main(void) {
        zim::printVersions(); // first line should print "libzim <version>"
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lzim", "-o", "test", "-std=c++11"

    # Assert the first line of output contains "libzim <version>"
    assert_match "libzim #{version}", shell_output("./test")
  end
end
