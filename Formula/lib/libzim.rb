class Libzim < Formula
  desc "Reference implementation of the ZIM specification"
  homepage "https://github.com/openzim/libzim"
  url "https://github.com/openzim/libzim/archive/refs/tags/9.2.0.tar.gz"
  sha256 "979ad974d2dbd7ed36241cd3da8abde394bfb6f1973e5f47c2ac6cb6d7af3a07"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "c03e7db8b12ae0e52ad2931f701e0178d305fa2069d2fac26fc234eb52fcd864"
    sha256 cellar: :any, arm64_ventura:  "7c6a36017202000f9c601837699a18b76edec4466d5b36275cf1c2bd286b4f16"
    sha256 cellar: :any, arm64_monterey: "0d8f510ad6136b4240fee2b62cbf81f1cebd5854d3e5ddc48bf18dd33c3aa6d9"
    sha256 cellar: :any, sonoma:         "145ac1f9abcc2ae950131a894948075cbb3b998f8f3d9adbd16f15896d4f46b7"
    sha256 cellar: :any, ventura:        "c158e80699e5f3bc7bbb0b547d10a224d7345bbc3cf4aa46f0bfd58746c2bda3"
    sha256 cellar: :any, monterey:       "223071d8598badfd7f68742f8b0a93f5c4ffa57f3b05edc814b74a2a73dc2e55"
    sha256               x86_64_linux:   "9ac9dcc360e30b73447816bf6bdf1d6008b06ea4a62c2b103c2daa9a107d3d45"
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
