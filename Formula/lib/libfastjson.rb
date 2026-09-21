class Libfastjson < Formula
  desc "Fast json library for C"
  homepage "https://github.com/rsyslog/libfastjson"
  url "https://download.rsyslog.com/libfastjson/libfastjson-1.2609.0.tar.gz"
  sha256 "7cd6f78c1c07f4140f6976a9a0e0048bcaa7292329c6ac2c0e070383d83d8edd"
  license "BSD-2-Clause"

  livecheck do
    url "https://download.rsyslog.com/libfastjson/"
    regex(/href=.*?libfastjson[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "78aa402a365cbdfe23042ab82037bbc55093dbbdedcb83c03c2ef3944727adb2"
    sha256 cellar: :any, arm64_tahoe:       "c9f3da9126446e3f611b4f20baac2ee72c8d54e6f96479b4225fa1a10e32174d"
    sha256 cellar: :any, arm64_sequoia:     "b2303ac802a20bad042e646029a0ceb69fe1eb60dae775cccbccf9381748d2b1"
    sha256 cellar: :any, arm64_sonoma:      "65d619a243fe5d037b90c99126a7f49c448d8d3a67fb4a4db173c8681d319552"
    sha256 cellar: :any, arm64_linux:       "d4e4ab6ee926c241f1f5ab125b02cbdbc2eaf8263b40213b0c8e2fe697cff88c"
    sha256 cellar: :any, x86_64_linux:      "91fd363bf416c418dc55557b6179913ffd24e0ac73bb798d3a0a1a32fd6e1f92"
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
