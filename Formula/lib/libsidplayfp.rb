class Libsidplayfp < Formula
  desc "Library to play Commodore 64 music"
  homepage "https://github.com/libsidplayfp/libsidplayfp"
  url "https://github.com/libsidplayfp/libsidplayfp/releases/download/v3.0.0/libsidplayfp-3.0.0.tar.gz"
  sha256 "b22fe5d3cc1e228733b23dd175573b00e677cf4d2a2b277fcdb7ababc0ff66a2"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9802ac3fc20b374564905242bd8db9ab6973bc7f7d6b69f4dc84b8d1b3220ea8"
    sha256 cellar: :any,                 arm64_sequoia: "65228ab9338c057178d5992a6dcd7cddb4f559f366aeb760d508112a10303e48"
    sha256 cellar: :any,                 arm64_sonoma:  "c8582d2c83ca7a3be4085e003399b83c78b1d74cff2db0fec074bdc3f38c4eb1"
    sha256 cellar: :any,                 sonoma:        "d5fb3b14b6bf4bb5b502ecb7ea69602fb33da379cebd0dfae541b9b5cbb459ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4be84c8b2db0127b2f5635b774e9a742c33252707ad7549bf852461031d8cd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbbf31d7a2bb9cd835717a480469d428f23e56a97fef0227392c65d6dd2205db"
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
