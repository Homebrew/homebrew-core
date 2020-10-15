class Opusfile < Formula
  desc "API for decoding and seeking in .opus files"
  homepage "https://www.opus-codec.org/"
  url "https://downloads.xiph.org/releases/opus/opusfile-0.12.tar.gz"
  sha256 "118d8601c12dd6a44f52423e68ca9083cc9f2bfe72da7a8c1acb22a80ae3550b"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    sha256 "c43c50e65738c25ef72af85e5509577314764c3dad0fb4c122704591d6f3a515" => :catalina
    sha256 "8754dfcc9abec5de74e8cd7af31614c06e8208bd623f9ad5446048ad14218a97" => :mojave
    sha256 "ff718107c425123a06270b62aa9a7bd3fee4f785d03dac21a58f7059720be22b" => :high_sierra
  end

  head do
    url "https://gitlab.xiph.org/xiph/opusfile.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libogg"
  depends_on "openssl@1.1"
  depends_on "opus"

  resource "music_48kbps.opus" do
    url "https://www.opus-codec.org/static/examples/samples/music_48kbps.opus"
    sha256 "64571f56bb973c078ec784472944aff0b88ba0c88456c95ff3eb86f5e0c1357d"
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    testpath.install resource("music_48kbps.opus")
    (testpath/"test.c").write <<~EOS
      #include <opus/opusfile.h>
      #include <stdlib.h>
      int main(int argc, const char **argv) {
        int ret;
        OggOpusFile *of;

        of = op_open_file(argv[1], &ret);
        if (of == NULL) {
          fprintf(stderr, "Failed to open file '%s': %i\\n", argv[1], ret);
          return EXIT_FAILURE;
        }
        op_free(of);
        return EXIT_SUCCESS;
      }
    EOS
    system ENV.cc, "test.c", "-I#{Formula["opus"].include}/opus",
                             "-L#{lib}",
                             "-lopusfile",
                             "-o", "test"
    system "./test", "music_48kbps.opus"
  end
end
