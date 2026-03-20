class Llhttp < Formula
  desc "Port of http_parser to llparse"
  homepage "https://llhttp.org/"
  url "https://github.com/nodejs/llhttp/archive/refs/tags/release/v9.3.1.tar.gz"
  sha256 "c14a93f287d3dbd6580d08af968294f8bcc61e1e1e3c34301549d00f3cf09365"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "35c5eb5a905ba0729cf2af32593498a8c62f289941e141c46836335b8e428a20"
    sha256 cellar: :any,                 arm64_sequoia: "5dce7dc5e8c5cea5bd819da5b4df5b8c07a88414cd26fed46c4800084007f39a"
    sha256 cellar: :any,                 arm64_sonoma:  "e5ec03abe69e8861845736d9c02392c0228dd14f2a972084d0f4d8e0d67cea3b"
    sha256 cellar: :any,                 sonoma:        "7a68099f251edee5ec013af565622c06569b7d46f66175edc04768230b71a7cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0ff9594e5ab4ef4bb38860f7a42ab5c27a1a774791ab08ceaed4268e8c0a4bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9758338dfa51d0eb47445d9a279a7e0525c3fd3a8aa4f2e4c9b2ffd48224023a"
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
