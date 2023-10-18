class Instead < Formula
  desc "Interpreter of simple text adventures"
  homepage "https://instead.hugeping.ru/"
  url "https://github.com/instead-hub/instead/archive/3.5.1.tar.gz"
  sha256 "53380f94be7f1ec46de309d513f7fe62a1c63d607a247715d87815e83a9c7d63"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:   "9b2a9f6f5a2e90d61b6166628584a8ca807daa7b4f9051d90291e472caf2efa3"
    sha256 arm64_ventura:  "a9bd5abdd248c65e952ba89d83fd9fddeee5e0f2ada884e5c470cefb37b4550e"
    sha256 arm64_monterey: "027b1dbae08e70a493d3428ba5b839f6975fbe778e235bcc25b6dbff7459f295"
    sha256 arm64_big_sur:  "1ebdc3da038ee74ffea51dbbfd6d1995ad039d33b25dac010788fdf990e1c947"
    sha256 sonoma:         "d9c1586348e3b24f3f838131f0af6574b864d93fec8f4a461c539ffa3c0fb6e2"
    sha256 ventura:        "ad301e7189388e7b7aede2ecfdeda2b243862c3a5136b3587b4c43a543929e4b"
    sha256 monterey:       "1e7d4e795c6b1515841bf5883c51a53d2ce8a2573daed5453664b455e45b250f"
    sha256 big_sur:        "69c76a665f06ecb7569a5ed4c468ad22355e2133dd160c57affe6f511e960b23"
    sha256 x86_64_linux:   "2c1fe3f4a6798671a55324a27faf2f1caadb1327f399a3b4ad0186945c7c9694"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gtk+3"
  depends_on "luajit"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"
  depends_on "sdl2_ttf"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DWITH_GTK2=OFF",
                    "-DWITH_LUAJIT=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "INSTEAD #{version} ", shell_output("#{bin}/instead -h 2>&1")
  end
end
