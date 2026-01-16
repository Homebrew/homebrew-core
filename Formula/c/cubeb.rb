class Cubeb < Formula
  desc "Cross-platform audio library"
  homepage "https://github.com/mozilla/cubeb"
  license "ISC"

  stable do
    url "https://github.com/mozilla/cubeb/archive/refs/tags/cubeb-0.2.tar.gz"
    sha256 "cac10876da4fa3b3d2879e0c658d09e8a258734562198301d99c1e8228e66907"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "527ff86b71c3491f320043c8143e5c52542fc498577a31dbede4c285bb3ed639"
    sha256 cellar: :any,                 arm64_sequoia:  "82458e11a000c10cb1268c1e9118c0d0e447fc40d49bb6e0426288ea87d05e1b"
    sha256 cellar: :any,                 arm64_sonoma:   "478c0b66412477519eeb295fe7788436e843af7f98e10df61de6f8a942235772"
    sha256 cellar: :any,                 arm64_ventura:  "b16ab1b2aea0c4cec3a8015e3ead96e97c59719c655ec87d94ed5b54d81b30f8"
    sha256 cellar: :any,                 arm64_monterey: "506fb6090f05b4275bde1aff78c0eb1bf72959fbeac5c53018c728863ef1195f"
    sha256 cellar: :any,                 arm64_big_sur:  "e56366a9d51f95c573e9bcc0a7f8985e4607cf88a9e6a87c0f2193a363c18a93"
    sha256 cellar: :any,                 sonoma:         "f209a91dc7b5b2bfbc35abce746a13a921301638b8dfa819845ca21387c4b17b"
    sha256 cellar: :any,                 ventura:        "0041ddd0e681a15e761608af2f419790b7f367629b45afd420c19ceb94f731b8"
    sha256 cellar: :any,                 monterey:       "0734f84782c17da435dc805f42c1af96506669ed1337aa8a0a20f486975d771a"
    sha256 cellar: :any,                 big_sur:        "06c2e45c008f9b2c6068c5ccb4adf3d4d7ca75e4b0b25429af1577391a6b2d8b"
    sha256 cellar: :any,                 catalina:       "98061577ff4699c6d87158764616203f1bc758a858c88683fd7f7f10f90e74b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "77b3bb04b39d06f00b3e2fc82d5cb29b4d4d370655fda6e9d1654841b429024f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d67a504265f1431f6a44b2d28d235ce3f565e4872bed9e2e26ef6d7ee9b6e41"
  end

  head do
    url "https://github.com/mozilla/cubeb.git", branch: "master"

    depends_on "cmake" => :build
  end

  depends_on "pkgconf" => :build

  on_linux do
    depends_on "pulseaudio"
  end

  def install
    if build.head?
      system "cmake", "-S", ".", "-B", "build",
                      "-DBUILD_SHARED_LIBS=ON",
                      "-DBUILD_TESTS=OFF",
                      "-DCMAKE_INSTALL_RPATH=#{rpath}",
                      *std_cmake_args
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    else
      system "autoreconf", "--force", "--install", "--verbose"
      system "./configure", "--disable-silent-rules", *std_configure_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <cubeb/cubeb.h>

      #define TEST(test, msg) \
        if ((test)) { \
          printf("PASS: %s\\n", msg); \
        } else { \
          printf("FAIL: %s\\n", msg); \
          goto end; \
        }

      /* Dummy callbacks to use for audio stream test */
      static long data_callback(cubeb_stream *stream, void *user, void *buffer,
          long nframes) {
        return nframes;
      }
      static void state_callback(cubeb_stream *stream, void *user_ptr,
          cubeb_state state) {}

      int main() {
        int ret;
        cubeb *ctx;
        char const *backend_id;
        cubeb_stream *stream;
        cubeb_stream_params params;

        /* Verify that the library initialises itself successfully */
        ret = cubeb_init(&ctx, "test_context");
        TEST(ret == CUBEB_OK, "initialise cubeb context");

        /* Verify backend id can be retrieved */
        backend_id = cubeb_get_backend_id(ctx);
        TEST(backend_id != NULL, "retrieve backend id");

        /* Verify that an audio stream gets opened successfully */
        params.format = CUBEB_SAMPLE_S16LE; /* use commonly supported       */
        params.rate = 48000;                /* parameters, so that the test */
        params.channels = 1;                /* doesn't give a false fail    */
        ret = cubeb_stream_init(ctx, &stream, "test_stream", params, 100,
          data_callback, state_callback, NULL);
        TEST(ret == CUBEB_OK, "initialise stream");

      end:
        /* Cleanup and return */
        cubeb_stream_destroy(stream);
        cubeb_destroy(ctx);
        return 0;
      }
    C
    system ENV.cc, "-o", "test", "#{testpath}/test.c", "-L#{lib}", "-lcubeb"
    refute_match(/FAIL:.*/, shell_output("#{testpath}/test"),
                    "Basic sanity test failed.")
  end
end
