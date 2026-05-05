class Opusfile < Formula
  desc "API for decoding and seeking in .opus files"
  homepage "https://www.opus-codec.org/"
  url "https://ftp.osuosl.org/pub/xiph/releases/opus/opusfile-0.12.tar.gz"
  mirror "https://github.com/xiph/opusfile/releases/download/v0.12/opusfile-0.12.tar.gz"
  sha256 "118d8601c12dd6a44f52423e68ca9083cc9f2bfe72da7a8c1acb22a80ae3550b"
  license "BSD-3-Clause"
  revision 2

  livecheck do
    url "https://ftp.osuosl.org/pub/xiph/releases/opus/"
    regex(%r{href=(?:["']?|.*?/)opusfile[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "750266cd9b303346651feabba1b39ffd5b5cd1d3927c6a06a5322c4888518e66"
    sha256 cellar: :any,                 arm64_sequoia: "9b6a9947fddd5dab71810fe2a740a199b6ff9731bad586f93c544fa78683cad3"
    sha256 cellar: :any,                 arm64_sonoma:  "c38acf5a1a76e31f9b92150113edd776d867db1524422ec4183fd8c435b3d080"
    sha256 cellar: :any,                 sonoma:        "67029b81b431b3d0f0e2a3804ed961c71d5c9f8ab3f6e17092134570e5a9fa51"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9f9251859e1d2d20063fc46bb1b22e0ce0dbb163747013347b88d7d3f75bf14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91e550edcd34b9e8eea57f61bc8b4604205528a9a5dec5e78d6a1bb7984e3efd"
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
    system ENV.cc, "test.c", "-I#{Formula["opus"].include}/opus",
                             "-L#{lib}",
                             "-lopusfile",
                             "-o", "test"
    system "./test", "sample.opus"
  end
end
