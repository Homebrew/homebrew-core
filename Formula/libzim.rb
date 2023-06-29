class Libzim < Formula
  desc "Reference implementation of the ZIM specification"
  homepage "https://github.com/openzim/libzim"
  url "https://download.openzim.org/release/libzim/libzim-8.2.0.tar.xz"
  sha256 "611f816a5f3cc725210f0b4d9676c203394b92a00d1a9f2b3934897cc364fd59"
  license "GPL-2.0-only"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_ventura:  "769fbe083b286842ace8be79b1a373e241ac832ec367ce5e6dbde74b6a4b65cd"
    sha256 cellar: :any, arm64_monterey: "73d68a7f4f6279f48350ca1c3c9cce8b7b5fbad10e05f64f6c4ef73bb55dbf35"
    sha256 cellar: :any, arm64_big_sur:  "6a03e9f8f95835cb7dbf6f1617ac96b24b90fb697f1fee650ab9984427fbfefa"
    sha256 cellar: :any, ventura:        "7fe2dfa2c608935d7d3e92b4e14c2965f93425c664a9396437859836b10ab245"
    sha256 cellar: :any, monterey:       "eb151da5c8bbffef6bc854c9ca17b32c0227f3ecc255a12c9f7907f581a7bf6b"
    sha256 cellar: :any, big_sur:        "2bca4515c10804375bd74446216c3df771b762ec841860acfef257b29690266a"
    sha256               x86_64_linux:   "4a072267ee757a8bfec5ab0527438e76014a46827b64e4fd50b1b50bcf604e3f"
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
