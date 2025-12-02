class Lit < Formula
  desc "Portable tool for LLVM- and Clang-style test suites"
  homepage "https://llvm.org"
  url "https://files.pythonhosted.org/packages/47/b4/d7e210971494db7b9a9ac48ff37dfa59a8b14c773f9cf47e6bda58411c0d/lit-18.1.8.tar.gz"
  sha256 "47c174a186941ae830f04ded76a3444600be67d5e5fb8282c3783fba671c4edb"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, all: "30d091941a71abc54232470d2b1ec34bd194ac2ff3af457c6ae8034243577e72"
  end

  depends_on "llvm" => :test
  depends_on "python@3.14"

  def python3
    which("python3.14")
  end

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
    ENV.prepend_path "PATH", Formula["llvm"].opt_bin

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
      config.test_format = lit.formats.ShTest(True)

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
