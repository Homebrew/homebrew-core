class Libzim < Formula
  desc "Reference implementation of the ZIM specification"
  homepage "https://github.com/openzim/libzim"
  url "https://github.com/openzim/libzim/archive/refs/tags/9.2.1.tar.gz"
  sha256 "4d1579cbb902aef46e561c3cd4cf2ed74148d84e1c79d9e42b4892c882fce88b"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "38900f62ca1c3c4fd7c1f72dbcaf9a84e62de1ab83a29596082e4d97fc1f6373"
    sha256 cellar: :any, arm64_ventura:  "ebd39e65fbe4f2766d89d0ce446046c37c1b9512de74e1b5499538c5141bf22e"
    sha256 cellar: :any, arm64_monterey: "66dc4702753c800f10cd4d5c3211ab40e5962e513d6866c99227d77fb00131de"
    sha256 cellar: :any, sonoma:         "e65ca74708e0d1fcaf32f8124076ac54f0441282915eb6b459b40d2414d39b58"
    sha256 cellar: :any, ventura:        "c04df34f2a0d287fbeb38343e388f839b773181a583b8b98ac8e350f807547d4"
    sha256 cellar: :any, monterey:       "726aa4a9ee929e6628920c8d71599652fe6686b9baed71d7f9f526d066d36edf"
    sha256               x86_64_linux:   "646387692490e899b515ea4fa89df71e5db44a4c5f16cd2dac26362e2e3165bc"
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
