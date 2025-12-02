class Libfastjson < Formula
  desc "Fast json library for C"
  homepage "https://github.com/rsyslog/libfastjson"
  url "https://download.rsyslog.com/libfastjson/libfastjson-1.2304.0.tar.gz"
  sha256 "ef30d1e57a18ec770f90056aaac77300270c6203bbe476f4181cc83a2d5dc80c"
  license "BSD-2-Clause"

  livecheck do
    url "https://download.rsyslog.com/libfastjson/"
    regex(/href=.*?libfastjson[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "dbb23a3103fbad3b4ae1a7b4a25630af8b2ce307ddabdf7b158eb8f1cc7e0ecc"
    sha256 cellar: :any,                 arm64_sequoia:  "e9a8424dc257099992210434ed1b30517d31ea60793715f5b2878421144ffa9e"
    sha256 cellar: :any,                 arm64_sonoma:   "a9ca39524509a82daa588a69d3f7cf2c930a9fd4343279a3ecf86ec47391852a"
    sha256 cellar: :any,                 arm64_ventura:  "60241a76f124b053b86c2d2aae88bc9655dde27ac892314e557e609346f42a9a"
    sha256 cellar: :any,                 arm64_monterey: "f609552d56e43460541b5727b4eeca56b6e1fe1869d2568a9f169391d7a8babb"
    sha256 cellar: :any,                 arm64_big_sur:  "34043c498dfd2eb920d60d9911d858ff876e425d8f4446832bf32845579ff3ab"
    sha256 cellar: :any,                 sonoma:         "d96f3473d8f41f3f2ebbe16c6749d7843b512ad125189015f901d4f2a0dc0fbd"
    sha256 cellar: :any,                 ventura:        "95477fb9a28ae78daed53b78035ef03fbee4479deb174cabc30e9ba2fbf5e265"
    sha256 cellar: :any,                 monterey:       "bb6916ba89160f0ec9f1905f663f0b0c623bd89a89880c7102310bf48e377ed5"
    sha256 cellar: :any,                 big_sur:        "2464cf02ed9f97e440aefc678d7333af4c863d662f27692f7e72b1a1f8f0aae2"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "d299d0516956ab148eeb6852c910e20e3e70c8629e039a7d8cfe861257659fbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "266edab578eec8f218daa890d0a7e17460a241a61b0a50bbd5ca31d2f4a03c5d"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <libfastjson/json.h>

      int main() {
        char json_string[]  = "{\\"message\\":\\"Hello world!\\"}";
        struct fjson_object* root;
        struct fjson_object* message;

        root = fjson_tokener_parse(json_string);
        if (root == NULL) {
          fprintf(stderr, "Parsing failed\\n");
          return 1;
        }

        if (fjson_object_object_get_ex(root, "message", &message)) {
          printf("%s\\n", fjson_object_get_string(message));
        } else {
          fprintf(stderr, "Failed to get 'message' field\\n");
        }

        fjson_object_put(root);

        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lfastjson", "-o", "test"
    system "./test"
  end
end
