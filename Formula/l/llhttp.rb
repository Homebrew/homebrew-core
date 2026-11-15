class Llhttp < Formula
  desc "Port of http_parser to llparse"
  homepage "https://llhttp.org/"
  url "https://github.com/nodejs/llhttp/archive/refs/tags/release/v9.4.4.tar.gz"
  sha256 "5600adb1498f82a9c719b8eb19310021737388e0d92362a6d47be532710d3c96"
  license "MIT"
  compatibility_version 2

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f4e39eb8013d06a5c1024ed858e1078fb50cc7d3d1ad7ea5d98c997116887056"
    sha256 cellar: :any, arm64_tahoe:       "f10729546842aeb4a2a3103e59ee508759f4a6f05229c31c8361ec0e18adfe14"
    sha256 cellar: :any, arm64_sequoia:     "e26231647b5093b77bc7d0a92328643efe1f58808971a7ee0a1ca3bddf0dbc57"
    sha256 cellar: :any, arm64_linux:       "06b057764c15b1d13b22b58d14b0d5913422463f66d89376a0900b30a55dc58c"
    sha256 cellar: :any, x86_64_linux:      "b87291b165dd4c2d66a6d4381acbb4dd6021a1e4df5f3188874b4cfdc6d2968d"
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
