class Llhttp < Formula
  desc "Port of http_parser to llparse"
  homepage "https://llhttp.org/"
  url "https://github.com/nodejs/llhttp/archive/refs/tags/release/v9.4.2.tar.gz"
  sha256 "ba717a2f99f340a0ee9796aaf2b1acca057e1e37682ffd2bc4def4d3b6bc4005"
  license "MIT"
  compatibility_version 2

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3514845e73dd4a73da75c3d1987bdc9f1fd2fe5fe105802949637d121574ba0e"
    sha256 cellar: :any, arm64_sequoia: "34f797447d817be2a6270575dd02f76202df0e0d1efe3bab84886737ecc21367"
    sha256 cellar: :any, arm64_sonoma:  "33c714e5e238acec82d0371f963eaa8562cd48e925991cd57e4f7b6b4bba05de"
    sha256 cellar: :any, sonoma:        "6f59e2eb68c14183982772d0b1ab49772158ef7f61dc046a976eb6e102cd61e9"
    sha256 cellar: :any, arm64_linux:   "3472902d226e0cdb2d06ec77635ddc0268d8ff4bfba8a4b995fd02d70d168b8e"
    sha256 cellar: :any, x86_64_linux:  "ee8bd70c57f0fde4aa367f16d91ee109849a3da003e0b1e262c754986d01a06c"
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
