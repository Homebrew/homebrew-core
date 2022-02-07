class Lit < Formula
  include Language::Python::Virtualenv

  desc "Portable tool for LLVM- and Clang-style test suites"
  homepage "https://llvm.org"
  url "https://files.pythonhosted.org/packages/9d/8e/a4570b82f17fe3bdc378fa41989c1652d57736918b3640b8acf5ce9dcb0b/lit-14.0.0.tar.gz"
  sha256 "45e08ce87b0ea56ab632aa02fa857418a5dd241a711c7c756878b73a130c3efe"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    sha256 cellar: :any_skip_relocation, all: "eda14ce09883580e7908095d11aa42acfc5058f9c9ab47471afa195f0da78c44"
  end

  depends_on "llvm" => :test
  depends_on "python@3.10"

  def install
    system "python3", *Language::Python.setup_install_args(prefix)

    # Install symlinks so that `import lit` works with multiple versions of Python
    python_versions = Formula.names
                             .select { |name| name.start_with? "python@" }
                             .map { |py| py.delete_prefix("python@") }
                             .reject { |xy| xy == Language::Python.major_minor_version("python3") }
    site_packages = Language::Python.site_packages("python3").delete_prefix("lib/")
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
      ENV.prepend_path "PYTHONPATH", prefix/Language::Python.site_packages("python3")
    else
      python = deps.reject { |d| d.build? || d.test? }
                   .find { |d| d.name.match?(/^python@\d+(\.\d+)*$/) }
                   .to_formula
      ENV.prepend_path "PATH", python.opt_bin
    end
    system "python3", "-c", "import lit"
  end
end
