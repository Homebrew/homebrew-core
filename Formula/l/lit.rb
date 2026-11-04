class Lit < Formula
  desc "Portable tool for LLVM- and Clang-style test suites"
  homepage "https://llvm.org"
  url "https://files.pythonhosted.org/packages/9f/7c/b268058aacea46e3479ea53b5ce84acbbf6491d993a86e51bfe4186cb5e4/lit-23.1.5.tar.gz"
  sha256 "532fac852fb0ed7359fee63978ea9212c2bb15541f0966625a7d3c9be5a9df89"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    sha256 cellar: :any_skip_relocation, all: "23b00a489f1fe7b0096dca4fcf38f16e747f5df5ea1c3e40583131b36014b9a3"
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
