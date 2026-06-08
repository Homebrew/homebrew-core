class Llhttp < Formula
  desc "Port of http_parser to llparse"
  homepage "https://llhttp.org/"
  url "https://github.com/nodejs/llhttp/archive/refs/tags/release/v9.4.1.tar.gz"
  sha256 "86a8c16759fdcc7aa2c9841fbe8ba2e77ea98be7d5d45615f2604776d0ff78c7"
  license "MIT"
  compatibility_version 2

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "008c27ccda18513f7b62a6ad142774acecc300cd6eeac9f5aac8fef748495ae0"
    sha256 cellar: :any,                 arm64_sequoia: "2e8334042c1afd61dcbdde7e24472889cf323cbec3d251b669ba9f5e79476bee"
    sha256 cellar: :any,                 arm64_sonoma:  "5cc1eba5deaab8a20bf1ba35469db8d693f6cf75726e0d88ae0c4170190df389"
    sha256 cellar: :any,                 sonoma:        "9d0428367d420235836b13a4d9db987a55c341b4e8eeea4756824827c85c8c41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44cc7ec6552fbbb70d026809c0c2a88caacad11e7eeeba9a9c02b1aa6cb86ac3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6fa60dfe50e4abe067f2295ffea6c4668fbfdec401edd73c6e16d70b9a8c6de"
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
