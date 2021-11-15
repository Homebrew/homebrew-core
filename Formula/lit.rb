class Lit < Formula
  include Language::Python::Virtualenv

  desc "Portable tool for LLVM- and Clang-style test suites"
  homepage "https://llvm.org"
  url "https://files.pythonhosted.org/packages/f7/fc/aba44ef618619519d4fb56e604163fd85f4b598a4fd8a105e32e4e456798/lit-13.0.0.tar.gz"
  sha256 "4da976f3d114e4ba6ba06cbe660ce1393230f4519c4df15b90bc1840f00e4195"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0cc9d6acafc45e2cbf37ec1ec2ad3947d55a805529822db741b4d4d70aedbe6a"
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
