class Jerryscript < Formula
  desc "Ultra-lightweight JavaScript engine for the Internet of Things"
  homepage "https://jerryscript.net"
  url "https://github.com/jerryscript-project/jerryscript/archive/v2.4.0.tar.gz"
  sha256 "5850947c23db6fbce032d15560551408ab155b16a94a7ac4412dc3bb85762d2d"
  license "Apache-2.0"
  head "https://github.com/jerryscript-project/jerryscript.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9fc5ed6b4d4694e46177bad3a5b3b8b6542e088224e10a4797e7bff39313077"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf6ac8f80cc4c6b10bd27113e49727d31cd6f8237e55362bd5fc6cb10fdfa9b8"
    sha256 cellar: :any_skip_relocation, monterey:       "fd07174dc19c1dc678c26de054b08b55cb4e0e5b425aed223a2f3c27bafece47"
    sha256 cellar: :any_skip_relocation, big_sur:        "b7884dc63baf21ca21f882e25f93397f0478dba8e0c4728a7efc7bfb198673ff"
    sha256 cellar: :any_skip_relocation, catalina:       "e6e1907eb1af3d6aab2f3447a0aa2e6c709ebb040d6198fefa7c12a1e256b8bd"
    sha256 cellar: :any_skip_relocation, mojave:         "c091f4246186278785265a7c378f2cd37db337d4c9419afc8348bcdd4d74e8ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0756095b89bd3051bf0c8bfb38b6dc8070b9eabe707afe77afe85698a69ad75"
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
                   "-ljerry-core", "-ljerry-port-default", "-ljerry-ext", "-lm"
    assert_equal "1 + 2 = 3", shell_output("./test").strip, "JerryScript can add number"
  end
end
