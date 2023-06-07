class Libuecc < Formula
  desc "Very small Elliptic Curve Cryptography library"
  homepage "https://git.universe-factory.net/libuecc/"
  url "https://git.universe-factory.net/libuecc/snapshot/libuecc-7.tar"
  sha256 "0120aee869f56289204255ba81535369816655264dd018c63969bf35b71fd707"
  head "https://git.universe-factory.net/libuecc", using: :git, branch: "master"

  livecheck do
    url :head
    regex(/href=.*?libuecc[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "52bf8320fc75e714e3b8ba3b6421fdb5165ab1719597539d20de7371c2b3a64b"
    sha256 cellar: :any,                 arm64_monterey: "015dfe9431583fd7f8638500cbb3ea7f812feb0c8db8bcb54f60c865ed3ca820"
    sha256 cellar: :any,                 arm64_big_sur:  "411158650719304f490887eb4a88d54a6a10ccee7238c7f7a92fb5407c312813"
    sha256 cellar: :any,                 ventura:        "59b7963752350f8eeb7b2c57330094648df6089bc0b4dd5b9b5a4515b1cfaf5e"
    sha256 cellar: :any,                 monterey:       "d23f6c3cf34a281bc6e206b3f10c52041f51d856fab87a28071afd10a06e3915"
    sha256 cellar: :any,                 big_sur:        "844327a3e5e6bed43c2ed9a36e3b7f6c8c871803fb5968f34ee6aa667fc345b8"
    sha256 cellar: :any,                 catalina:       "89acc7a04f910882b89d9e032a45e8c27dc98257d6d4e6b28f6c6a26c8c369ae"
    sha256 cellar: :any,                 mojave:         "d4d0c41262688ddca9ee2f2e6b80c33670c5a8db7266cd0c0592cd50b0d18be1"
    sha256 cellar: :any,                 high_sierra:    "95646c23acf19c1f07032c6f311f446e7a32b1a9d0c1dd385ec3c41811036572"
    sha256 cellar: :any,                 sierra:         "4722877fdc4538c814a10e6d0dc2f1a4d2a3571ce4ca1c8b37279c88cd83883f"
    sha256 cellar: :any,                 el_capitan:     "d9e52027a6535fb74e44026d23ef13a2417a1f22402173dc90d136071ea5290d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f4ead35052be0dce1efbee86333ca2bfb632cc3fb1bb00c8c836199f4f7d90c"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdlib.h>
      #include <libuecc/ecc.h>

      int main(void)
      {
          ecc_int256_t secret;
          ecc_25519_gf_sanitize_secret(&secret, &secret);

          return EXIT_SUCCESS;
      }
    EOS
    system ENV.cc, "-I#{include}/libuecc-#{version}", "-L#{lib}", "-o", "test", "test.c", "-luecc"
    system "./test"
  end
end
