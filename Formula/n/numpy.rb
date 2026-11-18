class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/4e/3a/8770c288c47f0b5c2a786d3c20e79f66fd245f2d42cd232d7cd5e00e83e5/numpy-2.5.5.tar.gz"
  sha256 "5cddc243c75114ba845f01b1f87aca1572dbf7b6c2d88636ed3e1d2bccd7f1bf"
  # TODO: Remove Zlib from license when release includes
  # https://github.com/numpy/numpy/commit/3d065710eee404a34788deb8f05f977a88879b20
  license all_of: ["BSD-3-Clause", "0BSD", "MIT", "Zlib", "CC0-1.0"]
  compatibility_version 1
  head "https://github.com/numpy/numpy.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6f53fade9bf1192c76dc8461b02e13970f072880482dafc5e41cdca44863624d"
    sha256 cellar: :any, arm64_tahoe:       "835a77ddb8ad8ef0f6029203951a38664da57570fb1f8be5105c38b025ab7cbc"
    sha256 cellar: :any, arm64_sequoia:     "5e93cdbb12d3d14625f0d519d30e4c410c0b5beea23f7990a7e36903288da393"
    sha256 cellar: :any, arm64_linux:       "d1e2d88eef6964c8005ebf3b8f6aa702817ec18ed19c4b42eda12d36f473ce71"
    sha256 cellar: :any, x86_64_linux:      "7df9055692026393f34536a385f5b03b57a0a3604bcf14b73a1589351f499841"
  end

  depends_on "gcc" => :build # for gfortran
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "python@3.14" => [:build, :test]
  depends_on "python@3.15" => [:build, :test]
  depends_on "openblas"

  on_linux do
    depends_on "patchelf" => :build
  end

  def pythons
    deps(/\Apython@3\.\d+\z/).map(&:to_formula)
                             .sort_by(&:version) # so scripts like `bin/f2py` use newest python
  end

  def install
    pythons.each do |python|
      python3 = python.opt_libexec/"bin/python"
      system python3, "-m", "pip", "install", "-Csetup-args=-Dblas=openblas",
                                              "-Csetup-args=-Dlapack=openblas",
                                              *std_pip_args(build_isolation: true), "."
    end
  end

  def caveats
    <<~EOS
      To run `f2py`, you may need to `brew install #{pythons.last}`
    EOS
  end

  test do
    pythons.each do |python|
      python3 = python.opt_libexec/"bin/python"
      system python3, "-c", <<~PYTHON
        import numpy as np
        t = np.ones((3,3), int)
        assert t.sum() == 9
        assert np.dot(t, t).sum() == 27
      PYTHON
    end
  end
end
