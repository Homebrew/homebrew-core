class Jerryscript < Formula
  desc "Ultra-lightweight JavaScript engine for the Internet of Things"
  homepage "https://jerryscript.net"
  url "https://github.com/jerryscript-project/jerryscript/archive/v2.3.0.tar.gz"
  sha256 "75f039f2e7eb55e3ce5d48fd6f9c4e8ec643a94654070125a6d76a906218e0fa"
  license "Apache-2.0"
  head "https://github.com/jerryscript-project/jerryscript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "30cce6deddb3cd879374dd6e80fc0a7ec7fcf32aa5b940713c60ee520b9b030a" => :catalina
    sha256 "aecaf8cb9cc69ed2ac8694691f3f8b40b16fe72ce30f1a571244aa9cbe0c0591" => :mojave
    sha256 "8c9890bfc739d8903d493316d3d1e258f6883d15115d247a8493aa259823cf47" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    args = std_cmake_args + %w[
      -DCMAKE_BUILD_TYPE=MinSizeRel
      -DJERRY_CMDLINE=ON
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "cmake", "--build", "."
      system "make", "install"
    end
  end

  test do
    (testpath/"test.js").write "print('Hello, Homebrew!');"
    assert_equal "Hello, Homebrew!", shell_output("#{bin}/jerry test.js").strip

    (testpath/"test.c").write <<~EOS
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
          printf("1 + 2 = %d\\n", (int) jerry_get_number_value(eval_ret));
        }

        jerry_release_value(eval_ret);
        jerry_cleanup();
        return (run_ok ? 0 : 1);
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-L#{lib}",
                   "-ljerry-core", "-ljerry-port-default", "-ljerry-ext"
    assert_equal "1 + 2 = 3", shell_output("./test").strip, "JerryScript can add number"
  end
end
