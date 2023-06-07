class Libzim < Formula
  desc "Reference implementation of the ZIM specification"
  homepage "https://github.com/openzim/libzim"
  url "https://download.openzim.org/release/libzim/libzim-8.2.0.tar.xz"
  sha256 "611f816a5f3cc725210f0b4d9676c203394b92a00d1a9f2b3934897cc364fd59"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "3efd0f8dd8c236c60b4db6bf506ee4b9319c9837d68f79c1b9de2dfaa6f56034"
    sha256 cellar: :any, arm64_monterey: "4fca03e1dbfa00c95b269617653a1c1573be999aaf455ed31cbc6e4c46e133ea"
    sha256 cellar: :any, arm64_big_sur:  "fc94236b1d7206d0d62173eb0533d9a7f1f3e8a3c98118b428386079049ed830"
    sha256 cellar: :any, ventura:        "164e81e6905a8ec8e2cbd7103cf9b79555b132a697b81d45d5e4374d941bd7dc"
    sha256 cellar: :any, monterey:       "78c1b3e752793455124754dc6d88aff1f9e67399ac7d884e796356ac17a68868"
    sha256 cellar: :any, big_sur:        "1c886828cb5c56f79532de423b04553e5a5c0fbe39bf2e2d4533a44de1e9fa51"
    sha256               x86_64_linux:   "4f4367e42fcc392e9c974ae464be35ea3c62b7784180a12fd7ac8d35d5d5278c"
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
