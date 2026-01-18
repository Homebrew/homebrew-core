class Libuecc < Formula
  desc "Very small Elliptic Curve Cryptography library"
  homepage "https://git.universe-factory.net/fastd/libuecc"
  url "https://git.universe-factory.net/fastd/libuecc/archive/v7.tar.gz"
  sha256 "80ef381fae912db88a33ebe1b4c7a722b98ed3b1939f75415068b025c5675818"
  license "BSD-2-Clause"
  head "https://git.universe-factory.net/fastd/libuecc.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "d27a92b37c542bc9880f60bdf8dce4dec889c93b469e8cfc855d963ade17f9f8"
    sha256 cellar: :any,                 arm64_sequoia:  "a94e6f279789d442ddfce719d48af0c5a430e4d255f9c8dd16b7cb691062988f"
    sha256 cellar: :any,                 arm64_sonoma:   "53fdfd07055f10ff583e922b59b5fd2da445ce9f3926ea76b6aaa9da3a036a5b"
    sha256 cellar: :any,                 arm64_ventura:  "52bf8320fc75e714e3b8ba3b6421fdb5165ab1719597539d20de7371c2b3a64b"
    sha256 cellar: :any,                 arm64_monterey: "015dfe9431583fd7f8638500cbb3ea7f812feb0c8db8bcb54f60c865ed3ca820"
    sha256 cellar: :any,                 arm64_big_sur:  "411158650719304f490887eb4a88d54a6a10ccee7238c7f7a92fb5407c312813"
    sha256 cellar: :any,                 sonoma:         "bc1bf4cc33f99950836c0dddc874c854d5db9303b123f0dadeac971b44eabadf"
    sha256 cellar: :any,                 ventura:        "59b7963752350f8eeb7b2c57330094648df6089bc0b4dd5b9b5a4515b1cfaf5e"
    sha256 cellar: :any,                 monterey:       "d23f6c3cf34a281bc6e206b3f10c52041f51d856fab87a28071afd10a06e3915"
    sha256 cellar: :any,                 big_sur:        "844327a3e5e6bed43c2ed9a36e3b7f6c8c871803fb5968f34ee6aa667fc345b8"
    sha256 cellar: :any,                 catalina:       "89acc7a04f910882b89d9e032a45e8c27dc98257d6d4e6b28f6c6a26c8c369ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "0856cd70a483837f05bc33484a8c23104e5e6bdd97b2bc04f30a837cadbe2e00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f4ead35052be0dce1efbee86333ca2bfb632cc3fb1bb00c8c836199f4f7d90c"
  end

  depends_on "cmake" => :build

  def install
    # Workaround to build with CMake 4
    args = %w[-DCMAKE_POLICY_VERSION_MINIMUM=3.5]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdlib.h>
      #include <libuecc/ecc.h>

      int main(void)
      {
          ecc_int256_t secret;
          ecc_25519_gf_sanitize_secret(&secret, &secret);

          return EXIT_SUCCESS;
      }
    C

    system ENV.cc, "-I#{include}/libuecc-#{version}", "-L#{lib}", "-o", "test", "test.c", "-luecc"
    system "./test"
  end
end
