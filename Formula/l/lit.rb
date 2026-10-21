class Lit < Formula
  desc "Portable tool for LLVM- and Clang-style test suites"
  homepage "https://llvm.org"
  url "https://files.pythonhosted.org/packages/76/67/6d87e456d61747fe3e61eca7024cb272cc441ff599bb416c99e6e6338bd1/lit-23.1.3.tar.gz"
  sha256 "a3d02402ddbc5ecd4df89fac6e64008e0fe6e4c7bafbb8fdb5dab5c50e1396ec"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "b54dec36fed5b49b4e9e403dd27e612573d3ba5a92582f659baad621ae6d44af"
  end

  depends_on "llvm" => :test
  depends_on "python@3.15"

  conflicts_with "luvit", because: "both install `lit` binaries"

  def install
    system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."

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
    ENV.prepend_path "PATH", formula_opt_bin("llvm")

    (testpath/"example.c").write <<~C
      // RUN: cc %s -o %t
      // RUN: %t | FileCheck %s
      // CHECK: hello world
      #include <stdio.h>

      int main() {
        printf("hello world");
        return 0;
      }
    C

    (testpath/"lit.site.cfg.py").write <<~PYTHON
      import lit.formats

      config.name = "Example"
      config.test_format = lit.formats.ShTest()

      config.suffixes = ['.c']
    PYTHON

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
