class Libunibreak < Formula
  desc "Implementation of the Unicode line- and word-breaking algorithms"
  homepage "https://github.com/adah1972/libunibreak"
  url "https://github.com/adah1972/libunibreak/releases/download/libunibreak_6_1/libunibreak-6.1.tar.gz"
  sha256 "cc4de0099cf7ff05005ceabff4afed4c582a736abc38033e70fdac86335ce93f"
  license "Zlib"

  livecheck do
    url :stable
    regex(/v?(\d+(?:[_-]\d+)+)$/i)
    strategy :git do |tags|
      tags.map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "f8e19cd9a1e7407650ab46af15961b94a709b7848d54d57d8243453ac7f79efb"
    sha256 cellar: :any,                 arm64_sequoia:  "0bed33fbc272073291fa047e1f72422aff56e83276de789d02a0f3f82f117b45"
    sha256 cellar: :any,                 arm64_sonoma:   "687db532bdd75f70882b9b40e0f5b14fdac91ce6c81a94067757e46cc6f84566"
    sha256 cellar: :any,                 arm64_ventura:  "66f1874dbc3a0761b53cf03a7a72d2ca161b129c251a922a4109f93be947086e"
    sha256 cellar: :any,                 arm64_monterey: "f14809e82b501d33b043d4943c9dcf5b8667adeddcefff7356d41c993575de35"
    sha256 cellar: :any,                 sonoma:         "e567abc03dc6d7df4bb3f5e6347dd58b8738d1b79cb03e151b44fce2ea9b6ce1"
    sha256 cellar: :any,                 ventura:        "60c6227dc928dca0478e06214ecb17f1e8103cfb42c7109509d4ed565acfde91"
    sha256 cellar: :any,                 monterey:       "871afc806ba2cae52184f857040c6b74f354025f502edebef37a443355994902"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "dc218bf31fe34b65e6888466900ffa5659033b9f1811e69034af6d2a87a2a1cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2662de1e1149d0aa2ed06f7bed26ab1ad27f7fc1bc5aa1689a9a320179b124a"
  end

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <unibreakbase.h>
      #include <linebreak.h>
      #include <assert.h>
      #include <stdlib.h>
      #include <string.h>
      int main() {
        static const utf8_t input[] = "test\\nstring \xF0\x9F\x98\x8A test";
        char output[sizeof(input) - 1];
        static const char expected[] = {
          2, 2, 2, 2, 0,
          2, 2, 2, 2, 2, 2, 1,
          3, 3, 3, 2, 1,
          2, 2, 2, 4
        };

        assert(sizeof(output) == sizeof(expected));

        init_linebreak();
        set_linebreaks_utf8(input, sizeof(output), NULL, output);

        return memcmp(output, expected, sizeof(output)) != 0;
      }
    C
    system ENV.cc, "-o", "test", "test.c", "-I#{include}",
                   "-L#{lib}", "-lunibreak"
    system "./test"
  end
end
