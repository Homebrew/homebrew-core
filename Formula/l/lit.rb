class Lit < Formula
  desc "Portable tool for LLVM- and Clang-style test suites"
  homepage "https://llvm.org"
  url "https://files.pythonhosted.org/packages/6e/77/2949345d1bab3ac2513377561cc823f96dcbc76fd9133b9ea8a824e75a5f/lit-18.1.1.tar.gz"
  sha256 "b687537151649101f9802b22615ffdd97e1ee90c07119129af09bf2bdca23472"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d108e9b9f850097d24dbe39a670283fcb1a953a141cce2d225035202b10e7498"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b89b796b84c2a7157fa6589fbe24bd01d90facd695f406d202f1d6040ef1b8d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86176d276e0deb7f75e7719053bc031deece7e5778b56fdc88c3592f300a3619"
    sha256 cellar: :any_skip_relocation, sonoma:         "084f42cd8636af8ee1f038b2d38da5b265a843a7f1f85df19d1b01495d82a914"
    sha256 cellar: :any_skip_relocation, ventura:        "d1100f694ef5823a0f2022f1cc9e206bf223c3fa3301e8320a0ed973374b14d2"
    sha256 cellar: :any_skip_relocation, monterey:       "73746b6a2d27d09fdd1c6abe2b6611441bbbafbb7ca75c22e92fed078dadbcd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02c934a185a050250deaf52b6e88aa0472967802fc048a4c359c5dd105523e74"
  end

  depends_on "python-setuptools" => :build
  depends_on "llvm" => :test
  depends_on "python@3.12"

  def python3
    which("python3.12")
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
