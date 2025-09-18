class Jerryscript < Formula
  desc "Ultra-lightweight JavaScript engine for the Internet of Things"
  homepage "https://jerryscript.net"
  url "https://github.com/jerryscript-project/jerryscript/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "4d586d922ba575d95482693a45169ebe6cb539c4b5a0d256a6651a39e47bf0fc"
  license "Apache-2.0"
  head "https://github.com/jerryscript-project/jerryscript.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "04e3aa7517ef94bc29b49da6892f29a2034a1433091bec5da32b16cca77a2f0d"
    sha256 cellar: :any,                 arm64_sequoia: "2c9278894af0e7dd27da2735af8ed66408de529fe2b896c9308ff2ffe10b695e"
    sha256 cellar: :any,                 arm64_sonoma:  "de8fb8e81f6cc123a414bd905c7f3d0da65f88b35d533a3cda511f88fcbef0dc"
    sha256 cellar: :any,                 arm64_ventura: "54b1c8bc94bc0c5f125e8f7ebab191540df56987dfc2e1a58c61ac6a5e25d2a9"
    sha256 cellar: :any,                 sonoma:        "28aa15489cdb4c63a3ca8dcabeb18bbf0937d16d7e627a19a3376936e2f1adbb"
    sha256 cellar: :any,                 ventura:       "2426c72ce0d91dd244fc0a4eb59a4912d6c753f090707a71367f9dd36f503751"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e969a7aa188293a61c458794e5673f6bc1012c48badcaeddfccb379bcc84e80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "700fa052538ab63fbaa0c9f8fda9ec3491777d6a65c4698e7ad488297bbbadcf"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test

  # rpath patch, upstream pr ref, https://github.com/jerryscript-project/jerryscript/pull/5204
  patch do
    url "https://github.com/jerryscript-project/jerryscript/commit/e8948ac3f34079ac6f3d6f47f8998b82f16b1621.patch?full_index=1"
    sha256 "ebce75941e1f34118fed14e317500b0ab69f48182ba9cce8635e9f62fe9aa4d1"
  end

  def install
    args = %w[
      -DCMAKE_BUILD_TYPE=MinSizeRel
      -DJERRY_CMDLINE=ON
      -DBUILD_SHARED_LIBS=ON
    ]

    system "cmake", "-S", ".", "-B", ".", *args, *std_cmake_args
    system "cmake", "--build", "."
    system "cmake", "--install", "."
  end

  test do
    (testpath/"test.js").write "print('Hello, Homebrew!');"
    assert_equal "Hello, Homebrew!", shell_output("#{bin}/jerry test.js").strip

    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include "jerryscript.h"

      int main (void)
      {
        const jerry_char_t script[] = "1 + 2";
        const jerry_length_t script_size = sizeof(script) - 1;

        jerry_init(JERRY_INIT_EMPTY);
        jerry_value_t eval_ret = jerry_eval(script, script_size, JERRY_PARSE_NO_OPTS);
        bool run_ok = !jerry_value_is_error(eval_ret);
        if (run_ok) {
          printf("1 + 2 = %d\\n", (int) jerry_value_as_number(eval_ret));
        }

        jerry_value_free(eval_ret);
        jerry_cleanup();
        return (run_ok ? 0 : 1);
      }
    C

    pkg_config_flags = shell_output("pkgconf --cflags --libs libjerry-core libjerry-port libjerry-ext").chomp.split
    system ENV.cc, "test.c", "-o", "test", *pkg_config_flags
    assert_equal "1 + 2 = 3", shell_output("./test").strip, "JerryScript can add number"
  end
end
