class Llhttp < Formula
  desc "Port of http_parser to llparse"
  homepage "https://llhttp.org/"
  url "https://github.com/nodejs/llhttp/archive/refs/tags/release/v9.4.3.tar.gz"
  sha256 "1eb813c7437b31a87496a1cd3ed79f00746720f5e7e29c79b42c02cb69f36c39"
  license "MIT"
  compatibility_version 2

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0a3866a86832c768383c04809baccccfa1293a520d3d13654d7c051f12c02c80"
    sha256 cellar: :any, arm64_sequoia: "661a11b740692ce17efa18e0d26d4c77e6e39bcdf0cc0ca53bd9a53ab4a4e71d"
    sha256 cellar: :any, arm64_sonoma:  "a00b9f89b26390cc28dd5fd70187f1830f1f1c9a9ea7df0b25faa7648137f014"
    sha256 cellar: :any, sonoma:        "a91b41d4c3ae2082308c3a2776d1e441289738801e14cddef2dbed6a6ea686a4"
    sha256 cellar: :any, arm64_linux:   "d2371130ab55225260beb7ef4e129cd43c8d9b6da4434c4086ec94c15fc8c7ea"
    sha256 cellar: :any, x86_64_linux:  "064d963ed771884697010f5bee50c78a8f82289cc5b0ff5793c001e5cd7acd27"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~'C'
      #include <stdio.h>
      #include <string.h>
      #include <llhttp.h>

      int handle_on_message_complete(llhttp_t* parser) {
        fprintf(stdout, "Message completed!\n");
        return 0;
      }

      int main(void) {
        llhttp_t parser;
        llhttp_settings_t settings;
        llhttp_settings_init(&settings);
        settings.on_message_complete = handle_on_message_complete;
        llhttp_init(&parser, HTTP_BOTH, &settings);

        const char* request = "GET / HTTP/1.1\r\n\r\n";
        int request_len = strlen(request);
        enum llhttp_errno err = llhttp_execute(&parser, request, request_len);

        if (err == HPE_OK) {
          fprintf(stdout, "Successfully parsed!\n");
          return 0;
        } else {
          fprintf(stderr, "Parse error: %s %s\n", llhttp_errno_name(err), llhttp_get_error_reason(&parser));
          return 1;
        }
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-lllhttp"
    assert_equal "Message completed!\nSuccessfully parsed!\n", shell_output("./test")
  end
end
