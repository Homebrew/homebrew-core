class Libde265 < Formula
  desc "Open h.265 video codec implementation"
  homepage "https://github.com/strukturag/libde265"
  url "https://github.com/strukturag/libde265/releases/download/v1.1.1/libde265-1.1.1.tar.gz"
  sha256 "fd48a927e94ed74fc7ce8829d222b9d8599fcbfe8b6448ba66705babc56ab219"
  license "LGPL-3.0-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c5219a5acb398bdd8e7da040df9e0cdfe78bd17fea28fcbe4efa818350d24c52"
    sha256 cellar: :any, arm64_sequoia: "205dcc543341461a96443fab87f518b9e2d62f845422b547727e90e110afa7eb"
    sha256 cellar: :any, arm64_sonoma:  "26e1dac41a928c1faf91ad459422124ed8fde2436b3f268284a21440605ff568"
    sha256 cellar: :any, sonoma:        "5d73539a71e8d73faa302801922053a6c29373d83a7ff4c2df5e98c8648bd70f"
    sha256 cellar: :any, arm64_linux:   "90b5b8e42034d39095bd3a2ff2affe1aa5c514ce690b146bc7bdb2dd39a354dc"
    sha256 cellar: :any, x86_64_linux:  "8cbb5f786788c23c300cc6704d9a426a935d938b37c562360510058ae1d1b319"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpath};#{rpath(source: libexec/"bin")}",
                    "-DENABLE_DECODER=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~'C'
      #include <libde265/de265.h>
      #include <stdio.h>
      #include <string.h>

      int main(void) {
        de265_decoder_context *ctx;
        const char *version = de265_get_version();

        if (strcmp(version, LIBDE265_VERSION) != 0) {
          return 1;
        }

        if (de265_init() != DE265_OK) {
          return 2;
        }

        ctx = de265_new_decoder();
        if (ctx == NULL) {
          de265_free();
          return 3;
        }

        printf("%s\n", version);

        de265_free_decoder(ctx);
        de265_free();

        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lde265", "-o", "test"
    assert_equal version.to_s, shell_output("./test").strip
  end
end
