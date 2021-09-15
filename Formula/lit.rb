class Lit < Formula
  include Language::Python::Virtualenv

  desc "Portable tool for LLVM- and Clang-style test suites"
  homepage "https://llvm.org"
  url "https://files.pythonhosted.org/packages/7c/0c/2d58790cb0fa24812382289a584e05dd1df4b30ccf5e2218ee5a556a0529/lit-12.0.1.tar.gz"
  sha256 "d2957aac5d560e98662a9fe7a2f5a485d2320ded2ef26e065e4fe871967ecf07"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1ff38c69b421d5ac0a758b5b2c0cd24fbdbef1c13757717e8a86181c4cd05503"
  end

  depends_on "llvm" => :test
  depends_on "python@3.9"

  def install
    system "python3", *Language::Python.setup_install_args(prefix)
  end

  test do
    ENV.prepend_path "PATH", Formula["llvm"].opt_bin

    (testpath/"example.c").write <<~EOS
      // RUN: cc %s -o %t
      // RUN: %t | FileCheck %s
      // CHECK: hello world
      #include <stdio.h>

      int main() {
        printf("hello world");
        return 0;
      }
    EOS

    (testpath/"lit.site.cfg.py").write <<~EOS
      import lit.formats

      config.name = "Example"
      config.test_format = lit.formats.ShTest(True)

      config.suffixes = ['.c']
    EOS

    system bin/"lit", "-v", "."
    system "python3", "-c", "import lit"
  end
end
