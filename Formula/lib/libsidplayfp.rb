class Libsidplayfp < Formula
  desc "Library to play Commodore 64 music"
  homepage "https://github.com/libsidplayfp/libsidplayfp"
  url "https://github.com/libsidplayfp/libsidplayfp/releases/download/v3.0.1/libsidplayfp-3.0.1.tar.gz"
  sha256 "6b8ffedc2f631a4ca53258e60468eab3e6a2dc4e1369b2e59e3a5955f99a2143"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "69c4987324a6eaa1065f86f163ffec361c69ce68a96c34feed4312ea4b4cd128"
    sha256 cellar: :any,                 arm64_sequoia: "25229d51be5e28a3c2158025c7fd5da6baa7ba35a8f559f9e4fb1302ededed9d"
    sha256 cellar: :any,                 arm64_sonoma:  "dd06a02193b11356d6986e7c7f8358ca4e8cc21343329e8ed4606027d7c44f25"
    sha256 cellar: :any,                 sonoma:        "de7a17072056d0ee80c192b6d9c54f69ac68d0dd705a422a785560015d0dba69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac464c1c9e7b3f970a76e954311ab604faca3fba1cb8580edf2f98fc8ac696e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e14acb29bdb264ff2b1d8b89cf469196b004d95d940051dbe8ae2361a63350f3"
  end

  head do
    url "https://github.com/libsidplayfp/libsidplayfp.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "coreutils" => :build
    depends_on "libtool" => :build
    depends_on "xa" => :build
  end

  depends_on "pkgconf" => :build

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <sidplayfp/sidplayfp.h>

      int main() {
          sidplayfp play;
          std::cout << LIBSIDPLAYFP_VERSION_MAJ << "."
                    << LIBSIDPLAYFP_VERSION_MIN << "."
                    << LIBSIDPLAYFP_VERSION_LEV;
          return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-L#{lib}", "-I#{include}", "-lsidplayfp", "-o", "test"
    assert_equal version.to_s, shell_output("./test")
  end
end
