class Libopusenc < Formula
  desc "Convenience library for creating .opus files"
  homepage "https://www.opus-codec.org/"
  url "https://ftp.osuosl.org/pub/xiph/releases/opus/libopusenc-0.3.tar.gz"
  mirror "https://archive.mozilla.org/pub/opus/libopusenc-0.3.tar.gz"
  sha256 "f616d3aff9b2034547894ccb8ab56c36cf1a4acb0d922c5d7119f97bbe58642c"
  license "BSD-3-Clause"

  livecheck do
    url "https://ftp.osuosl.org/pub/xiph/releases/opus/?C=M&O=D"
    regex(%r{href=(?:["']?|.*?/)libopusenc[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "92b42832d01a85d2be1e22d430d80fe57e02987ebf6b4e77f425891f4c1ae3e0"
    sha256 cellar: :any,                 arm64_sequoia: "cf8745f39fc22033d57343bc4d985d7797f6733d882c4a7fc1f47d76b306180d"
    sha256 cellar: :any,                 arm64_sonoma:  "ef3d476998cfb36e1ce4020f565fba423bf866578fded146753b03a8f224c8b6"
    sha256 cellar: :any,                 sonoma:        "4c4fd7d3596d74477da965719a66a3684007ae2ba31dc482a8a25ec6f57feb90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96d744e47f001702d08a26bccbeeda29d1ddfd1b14efd323ab0c9117e6d701c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "090f5e5a9c1ff5dc82c371154d4c1394d3e85d4dbbb27759552766734c3f1750"
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
