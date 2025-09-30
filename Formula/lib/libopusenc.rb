class Libopusenc < Formula
  desc "Convenience library for creating .opus files"
  homepage "https://www.opus-codec.org/"
  url "https://ftp.osuosl.org/pub/xiph/releases/opus/libopusenc-0.2.1.tar.gz"
  mirror "https://archive.mozilla.org/pub/opus/libopusenc-0.2.1.tar.gz"
  sha256 "8298db61a8d3d63e41c1a80705baa8ce9ff3f50452ea7ec1c19a564fe106cbb9"
  license "BSD-3-Clause"

  livecheck do
    url "https://ftp.osuosl.org/pub/xiph/releases/opus/?C=M&O=D"
    regex(%r{href=(?:["']?|.*?/)libopusenc[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "075a843ef1a2380fa68af791012dfd85f42bde013162651ac808b6aae66bd55f"
    sha256 cellar: :any,                 arm64_sequoia:  "9c857d079a3c385ac89d89869fa2ed74d6115a3b86d87149bd9d4d5796da3141"
    sha256 cellar: :any,                 arm64_sonoma:   "c96d078c67fa9ad9ae0398e4c7979c6506c4438ed426d224c8480a5cddd1d919"
    sha256 cellar: :any,                 arm64_ventura:  "2d9e6657c2d76d193da5cd687e5c95e4c13702cd9f5c08945b7a316b63786112"
    sha256 cellar: :any,                 arm64_monterey: "5b28442f84fbd88cfd6cacf35ad6df119cc1dcfb89851c7b81bd77f07402a70c"
    sha256 cellar: :any,                 arm64_big_sur:  "f8d28846ea6d21358ef7768f94241a0f94327d4edcdd5223be2da96c2f0d6841"
    sha256 cellar: :any,                 sonoma:         "340d398550ddcfdf633eb19d78a9f044e810ca5bcf0789fe66caec6a1c546269"
    sha256 cellar: :any,                 ventura:        "5b2a64d3c64ec7e14f7a9f2adbe46dddf4f3ad51876dea2c28010e6f4e4e55f1"
    sha256 cellar: :any,                 monterey:       "636d36637bb7e7cc098dfe6ba078fb4fb1fbc5fce4bd93ea6a7c08ad4c49d2f4"
    sha256 cellar: :any,                 big_sur:        "48157970f8bebbd7ad54d099531397cb3d81797e7715ed5523865d7d1b19df8b"
    sha256 cellar: :any,                 catalina:       "593106e48c86436fd1908c79f1ef54f206bb37f0983ccb3901190cebe6e78cea"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "c48463ee524577ba28625f68966b402ddd0e90ae2a576c4ea7ffcc59a90ece28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2545d8277065ed72d4a382d804569d27c55e9d8eb6ffc9511140bda90721edb3"
  end

  head do
    url "https://gitlab.xiph.org/xiph/libopusenc.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "opus"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <opusenc.h>
      #include <assert.h>
      #include <stdint.h>
      #include <stdlib.h>
      int main() {
        OggOpusComments *comments = ope_comments_create();
        assert(comments);
        ope_comments_add(comments, "ARTIST", "Homebrew");
        ope_comments_add(comments, "TITLE", "Test Track");

        int error;
        OggOpusEnc *enc = ope_encoder_create_file("test.opus",
          comments, 48000, 2, 0, &error);;
        assert(error == OPE_OK);
        assert(enc);
        ope_comments_destroy(comments);

        int16_t *buffer = calloc(1920, 2*sizeof(*buffer));
        error = ope_encoder_write(enc, buffer, 1920*2*sizeof(*buffer));
        assert(error == OPE_OK);

        error = ope_encoder_drain(enc);
        assert(error == OPE_OK);
        ope_encoder_destroy(enc);

        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-Wall",
                   "-I#{Formula["opus"].opt_include}/opus",
                   "-I#{include}/opus",
                   "-L#{lib}", "-lopusenc"
    system "./test"
  end
end
