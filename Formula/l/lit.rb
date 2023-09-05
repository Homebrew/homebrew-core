class Lit < Formula
  include Language::Python::Virtualenv

  desc "Portable tool for LLVM- and Clang-style test suites"
  homepage "https://llvm.org"
  url "https://files.pythonhosted.org/packages/bf/fa/0b75c53253ebf3ab566be702a9da16f5783862d8c1ae404c907a8830f283/lit-16.0.6.tar.gz"
  sha256 "84623c9c23b6b14763d637f4e63e6b721b3446ada40bf7001d8fee70b8e77a9a"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "298d8a706d5d6bba84af7dddbbc272105e7a5df96b6b10808180af27e447c73c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abe1ece83d737b1bdf63cbff18a5821c55657eaa7dd4759a2eb0e361e86a1f7c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "85c02bb81a6cbd4d8542012918ede1038ebd85dea50e880b322c580aae32f564"
    sha256 cellar: :any_skip_relocation, ventura:        "d2e9f12e4bd6dd82571197e9c93d1c5b6d227c3f27209fe325c9375256cfc0b2"
    sha256 cellar: :any_skip_relocation, monterey:       "0918b34b39e86dac41c5b548aafc8b11ec6292bd3b448ed4298e5008541bf874"
    sha256 cellar: :any_skip_relocation, big_sur:        "1740d9638df0c84fb1396c0019a3a0f11177474a20d6d75bfdcf28f5cdfa3118"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ee9c28173ee2079211cf6c353aa0aa036b23d8c662f3cff2cc20c975b749f06"
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
