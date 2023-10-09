class Lit < Formula
  include Language::Python::Virtualenv

  desc "Portable tool for LLVM- and Clang-style test suites"
  homepage "https://llvm.org"
  url "https://files.pythonhosted.org/packages/83/47/b77c3319905a5127ca9c90a626581f3cce389d3582b01afb3fc83d164773/lit-17.0.2.tar.gz"
  sha256 "d6a551eab550f81023c82a260cd484d63970d2be9fd7588111208e7d2ff62212"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d061477126f30376e7c28fa320ac5d648f9b28e50efa883f4a76e5c125f3f59e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94619798849dd932dedcf8b99d9657b726fd8e4bf20cd73d06b42ca4aed45119"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b75630843d2179169d3ca679c7ca4d5e703ebe5d8d54532f00b43f0876f4c3b5"
    sha256 cellar: :any_skip_relocation, sonoma:         "d307e804d7f83eb6b728e52bf6603ed74740669c574d20b10589cc4364ba37e8"
    sha256 cellar: :any_skip_relocation, ventura:        "99a1baed7b3fa66080d8c954f6d26bb6223ebcc5051a1889942b012df1b011b4"
    sha256 cellar: :any_skip_relocation, monterey:       "48d554ba1d3c144b92ab7da28a3ba6125897db7670e2f7d4c43ed4c1608ce4d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4d0e46171eda35e0d3c2c6e4f7d67e4e183a9e88032d4629593c4a6e882a6ee"
  end

  depends_on "llvm" => :test
  depends_on "python@3.11"

  def python3
    which("python3.11")
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."

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
