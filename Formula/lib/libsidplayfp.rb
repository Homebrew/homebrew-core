class Libsidplayfp < Formula
  desc "Library to play Commodore 64 music"
  homepage "https://github.com/libsidplayfp/libsidplayfp"
  url "https://github.com/libsidplayfp/libsidplayfp/releases/download/v2.16.1/libsidplayfp-2.16.1.tar.gz"
  sha256 "ace0f73c2ef8645ab069ce1b298b10e31e36af7b5996109983b2b67ad60ff3ca"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b4e8bd9e2d458c17ce895240352279188cb802ca03d28557f85f1e6045eb81cb"
    sha256 cellar: :any,                 arm64_sequoia: "0e1f398dcdfdd193e2e85c820f5549918b48e9b8d71e1313c059f0dea8136ae5"
    sha256 cellar: :any,                 arm64_sonoma:  "dc9ba9117d51c55362f71cb2ca50d7907526f2cb9ce09c56bf9b21313938d953"
    sha256 cellar: :any,                 sonoma:        "12268da95535d62e016d9e358206b19af1d20c74e51c7fa3eb6a1e0b13e6c176"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8b710c5a3c78a41f8fcdccf57849459572733c58746aea2161be90737c178c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85066022ede61620945cc9777e6983209c16053ff1e9f307a75234ddcea295ed"
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
  depends_on "libgcrypt"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
