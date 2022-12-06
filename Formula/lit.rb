class Lit < Formula
  include Language::Python::Virtualenv

  desc "Portable tool for LLVM- and Clang-style test suites"
  homepage "https://llvm.org"
  url "https://files.pythonhosted.org/packages/3c/e4/aa93b44e5983672069f608e96624eab10890d2361fe0b18546d605bdcb1a/lit-15.0.6.tar.gz"
  sha256 "4b4e8e41f0e60f2bad96cdb51f1c90d35ea4bb71534ec0ce3fc0e2ebb77d7fe9"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "532fa552d46762c2cd5d9e969737624e6912216ab5ee1dd45cc4a1d3b40fafcc"
  end

  depends_on "llvm" => :test
  depends_on "python@3.11"

  def python3
    "python3.11"
  end

  def install
    system python3, *Language::Python.setup_install_args(prefix, python3)

    # Install symlinks so that `import lit` works with multiple versions of Python
    python_versions = Formula.names
                             .select { |name| name.start_with? "python@" }
                             .map { |py| py.delete_prefix("python@") }
                             .reject { |xy| xy == Language::Python.major_minor_version(python3) }
    site_packages = Language::Python.site_packages(python3).delete_prefix("lib/")
    python_versions.each do |xy|
      (lib/"python#{xy}/site-packages").install_symlink (lib/site_packages).children
    end
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

    if OS.mac?
      ENV.prepend_path "PYTHONPATH", prefix/Language::Python.site_packages(python3)
    else
      python = deps.reject { |d| d.build? || d.test? }
                   .find { |d| d.name.match?(/^python@\d+(\.\d+)*$/) }
                   .to_formula
      ENV.prepend_path "PATH", python.opt_bin
    end
    system python3, "-c", "import lit"
  end
end
