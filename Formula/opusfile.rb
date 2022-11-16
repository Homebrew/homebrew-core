class Opusfile < Formula
  desc "API for decoding and seeking in .opus files"
  homepage "https://www.opus-codec.org/"
  url "https://downloads.xiph.org/releases/opus/opusfile-0.12.tar.gz", using: :homebrew_curl
  mirror "https://ftp.osuosl.org/pub/xiph/releases/opus/opusfile-0.12.tar.gz"
  sha256 "118d8601c12dd6a44f52423e68ca9083cc9f2bfe72da7a8c1acb22a80ae3550b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "36711acb9ef28f156240cf9844801ed8a6bdafa517ba75cc88f3e00d4b8e4bd1"
    sha256 cellar: :any,                 arm64_monterey: "0cdc27b38be83f9e0e7a2ca87d2b5605d597f702b8ae0e6b9f7470b203debf94"
    sha256 cellar: :any,                 arm64_big_sur:  "4274c0f9758385bbf30fabde125317dcf4934e5188d86b791cb1292efb9e26fd"
    sha256 cellar: :any,                 ventura:        "73c8b6c9dd81e8b3a8d33498659757468c29bc3c255318287eed5dd0b40690fe"
    sha256 cellar: :any,                 monterey:       "2b33775ddb195a0de0ae029b833c425db68ae92ed0228f2f508a202ef620823d"
    sha256 cellar: :any,                 big_sur:        "0e6dc752d650542ea8ae4b67182700724ae32ffd5dfa9323d5c2563ed267dd0f"
    sha256 cellar: :any,                 catalina:       "c43c50e65738c25ef72af85e5509577314764c3dad0fb4c122704591d6f3a515"
    sha256 cellar: :any,                 mojave:         "8754dfcc9abec5de74e8cd7af31614c06e8208bd623f9ad5446048ad14218a97"
    sha256 cellar: :any,                 high_sierra:    "ff718107c425123a06270b62aa9a7bd3fee4f785d03dac21a58f7059720be22b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9279801d0c9111e570f0e095f738d68a3eae182b8d9d6cb0cd6343a25b787644"
  end

  head do
    url "https://gitlab.xiph.org/xiph/opusfile.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libogg"
  depends_on "openssl@1.1"
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
    system "./test", "sample.opus"
  end
end
