class Libzim < Formula
  desc "Reference implementation of the ZIM specification"
  homepage "https://github.com/openzim/libzim"
  url "https://github.com/openzim/libzim/archive/refs/tags/9.1.0.tar.gz"
  sha256 "faf19a35882415212d46a51aab45692ccfa1e2e36beb7261eec1ec53e29b9e6a"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "c044656013242d1a0113bb99af94305f328d3675cbdefccde51c3ea440a2f3be"
    sha256 cellar: :any, arm64_ventura:  "4451337bb81d513d647f6297d49d3551cdaa24c4f7f05ff89433bc7a46c3a62a"
    sha256 cellar: :any, arm64_monterey: "4c6172d801427f39807539ed00173b5ca7c936f438c61d344ca9d25536bf767f"
    sha256 cellar: :any, sonoma:         "25a65da161d1d1c11bf1fb91f33edb4888451d33476294d39f21d233809c0442"
    sha256 cellar: :any, ventura:        "64df96b15ce8b9f875cb75ed4261918960634012feeef530cb35b8d8405eb2b3"
    sha256 cellar: :any, monterey:       "d5c067d177639bd733919e34b467fe56a8fa1129f38ab0e45bfa51eb1028f5c6"
    sha256               x86_64_linux:   "198ea2e2391fe6942cdcb1928a75ca08546acfce2b286e78d70a0848bff120f9"
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
