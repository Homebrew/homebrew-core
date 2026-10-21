class Fypp < Formula
  include Language::Python::Virtualenv

  desc "Python powered Fortran preprocessor"
  homepage "https://fypp.readthedocs.io/en/stable/"
  url "https://files.pythonhosted.org/packages/bb/a8/e156637279a91880d477a8afeb13097f438e46af332c5c1996fed10369f5/fypp-3.3.tar.gz"
  sha256 "14bb98c370873624c0a5e53bcf30f6ef0e1a3885e0f0cc714774c745ed8543f1"
  license "BSD-2-Clause"
  head "https://github.com/aradi/fypp.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "f6b6a6d36e74518217f6d23f153428bc0e46ff091eee77e5afbc63605af3822e"
  end

  depends_on "gcc" => :test
  depends_on "python@3.15"

  def install
    system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
  end

  test do
    system bin/"fypp", "--version"

    (testpath/"test_fypp.py").write <<~PYTHON
      import fypp
      print("fypp version:", fypp.VERSION)
    PYTHON
    system python3, testpath/"test_fypp.py"

    (testpath/"hello.F90").write <<~FORTRAN
      program hello
      #:for val in [_SYSTEM_, _MACHINE_, _FILE_, _LINE_]
        print *, '${val}$'
      #:endfor
      end
    FORTRAN

    system bin/"fypp", testpath/"hello.F90", testpath/"hello.f90"
    ENV.fortran
    system ENV.fc, testpath/"hello.f90", "-o", testpath/"hello"
    system testpath/"hello"
  end
end
