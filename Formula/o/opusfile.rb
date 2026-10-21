class Opusfile < Formula
  desc "API for decoding and seeking in .opus files"
  homepage "https://www.opus-codec.org/"
  url "https://ftp.osuosl.org/pub/xiph/releases/opus/opusfile-0.12.tar.gz"
  mirror "https://github.com/xiph/opusfile/releases/download/v0.12/opusfile-0.12.tar.gz"
  sha256 "118d8601c12dd6a44f52423e68ca9083cc9f2bfe72da7a8c1acb22a80ae3550b"
  license "BSD-3-Clause"
  revision 3

  livecheck do
    url "https://ftp.osuosl.org/pub/xiph/releases/opus/"
    regex(%r{href=(?:["']?|.*?/)opusfile[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "580b2a76a003a6d5afe91122cc0f010218b1e7dc32f7325e3b6ab8fc8afda755"
    sha256 cellar: :any, arm64_tahoe:       "b0226b89dd01ee7b757ca8f0a683bb3486ebd56a066333bb7f0c4df1f9b1ff7c"
    sha256 cellar: :any, arm64_sequoia:     "14df475fe484095b299c6fb39c5f63eede59b081da7ca468561a0a587507ecc6"
    sha256 cellar: :any, arm64_linux:       "4f2a88200a058fdf3ac0afdba41e85c583d67d2bc5984dc814b11331a9a3ab73"
    sha256 cellar: :any, x86_64_linux:      "0a219fc196b1906e1f597969e6d720b00752334a9ffc5fbfeb43de5e70ad593d"
  end

  head do
    url "https://gitlab.xiph.org/xiph/opusfile.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "libogg"
  depends_on "openssl@4"
  depends_on "opus"

  resource "sample" do
    url "https://dl.espressif.com/dl/audio/gs-16b-1c-44100hz.opus"
    sha256 "f80fabebe4e00611b93019587be9abb36dbc1935cb0c9f4dfdf5c3b517207e1b"
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    resource("sample").stage { testpath.install Pathname.pwd.children(false).first => "sample.opus" }
    (testpath/"test.c").write <<~C
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
    C
    system ENV.cc, "test.c", "-I#{formula_opt_include("opus")}/opus",
                             "-L#{lib}",
                             "-lopusfile",
                             "-o", "test"
    system "./test", "sample.opus"
  end
end
