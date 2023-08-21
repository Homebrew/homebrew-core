class Libzim < Formula
  desc "Reference implementation of the ZIM specification"
  homepage "https://github.com/openzim/libzim"
  url "https://download.openzim.org/release/libzim/libzim-8.2.1.tar.xz"
  sha256 "fcddb400cb71b2c21d5da86fd606e0f45083873f0df5d4529345855a39b5707c"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "b32179995f464b76d374d1d34502fb21c00303e3ced9b353953ac2320dee8eb2"
    sha256 cellar: :any, arm64_monterey: "54112606a0c0a8aa3fa1084e8978f92604124e12ad4584aa0f8df8cc01c62ad0"
    sha256 cellar: :any, arm64_big_sur:  "e0a3011dc1e857f84f77e2a9e0b56e2c730f954f22f8ff9a191f873e66290444"
    sha256 cellar: :any, ventura:        "0acf18de8f6cd3d2bbc8e4dff266af813466dedaae89e9cfc5f93a3c1116e9e0"
    sha256 cellar: :any, monterey:       "7298365283c04ea9a9e1917d94f1348f2fd28da409b223ed2d185847f57eb770"
    sha256 cellar: :any, big_sur:        "15997699641928c370eec76dd3a8f52bc614d19d6b8c89a2e7cac5b162c07c66"
    sha256               x86_64_linux:   "b59dae0b79f9d692ffb5ff2aecf4d468a984b1a99bc5e2a3b56d64ddbc300a38"
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
