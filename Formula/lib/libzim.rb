class Libzim < Formula
  desc "Reference implementation of the ZIM specification"
  homepage "https://download.openzim.org/release/libzim/"
  url "https://github.com/openzim/libzim/archive/refs/tags/9.8.1.tar.gz"
  sha256 "718d82930949de8eae14809de1af92414071811ba68c91e9ad0abb1fe3287799"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7ceb8f1c43e26286a77f9a8d2d9871b5ea1961f6467ed9499f27ebcb7d97cf08"
    sha256 cellar: :any, arm64_sequoia: "500aa99f46314e7f2c1dcaaa9b0e8478b61193ca60977c427f98f2c2ba76259b"
    sha256 cellar: :any, arm64_sonoma:  "3037274491ddf8db9ea721f9b2f97730f413a2c02291f0c514dbd3a78041cdda"
    sha256 cellar: :any, sonoma:        "4135a61edfd43c55c0a90093b45b47ff902dff96a645555b1e16cb9ac607409d"
    sha256               arm64_linux:   "e732ef4067575414e94735e246927af1fc4b6b211aa510740eab9dfe687c7b8b"
    sha256               x86_64_linux:  "e2eace78dbf9bcf663c3409c65d0e24ca11f21ebc2cc35ac066ed16161f5f6e1"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "icu4c@78"
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
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <zim/version.h>
      int main(void) {
        zim::printVersions(); // first line should print "libzim <version>"
        return 0;
      }
    CPP

    system ENV.cxx, "test.cpp", "-L#{lib}", "-lzim", "-o", "test", "-std=c++11"
    assert_match "libzim #{version}", shell_output("./test")
  end
end
