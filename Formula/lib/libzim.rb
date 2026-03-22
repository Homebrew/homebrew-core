class Libzim < Formula
  desc "Reference implementation of the ZIM specification"
  homepage "https://github.com/openzim/libzim"
  url "https://github.com/openzim/libzim/archive/refs/tags/9.5.1.tar.gz"
  sha256 "5f4ac87887b05a6eaa408b4f03d3486262c8a5c13e488024822b293cdefe8c0e"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "bd0854df1cc0f725db980924e90362a97bde97b9a95d449d96b90ead26156725"
    sha256 cellar: :any, arm64_sequoia: "3f31e8d87aa391642406b5521df0a85d28f495fedfba6291e541447c6f8aea77"
    sha256 cellar: :any, arm64_sonoma:  "51170cbb8ff7ec8048838b8b2c2e6735c8b7e97f8ba99922ffde056a5cf56d95"
    sha256 cellar: :any, sonoma:        "812e62c6628c002e8c3ce4fb840ad2e3e59ffe77979a2b94ab077ce442deed79"
    sha256               arm64_linux:   "8099f298a2b3ef1e61797f7547cf850407b37bca7bd17f67c3123649100d0bc0"
    sha256               x86_64_linux:  "571a3591a380797a8516a89b31b221888c1c7dfa1d961d67263553efbef6d577"
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
