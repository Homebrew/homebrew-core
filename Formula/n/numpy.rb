class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/47/1b/1d565e0f6e156e1522ab564176b8b29d71e13d8caf003a08768df3d5cec5/numpy-2.2.0.tar.gz"
  sha256 "140dd80ff8981a583a60980be1a655068f8adebf7a45a06a6858c873fcdcd4a0"
  license "BSD-3-Clause"
  head "https://github.com/numpy/numpy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2f200bdc987706a148d0d27b8e04a4985919115143143269434f14b7c3cf5862"
    sha256 cellar: :any,                 arm64_sonoma:  "57282ea0d427a55fcc107b3bd583ce94cf7f052e649f2d9151033e32c1e7226c"
    sha256 cellar: :any,                 arm64_ventura: "4a3f265f4767d15e1dc9ae74285a202b54933d376f78e29a4bee654153a35eb3"
    sha256 cellar: :any,                 sonoma:        "9d673e339b3e923d3fc44bb94f02c7c4e293a0cbf5d7349645d328b6716ccc6c"
    sha256 cellar: :any,                 ventura:       "c886bcf4c4d8321b64438895adc823f069583fc335decece51fb39095b68aebf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c4c1045279d796d31b8583083d81651090ec41aa9e46b2badfc0d5333fa5d0a"
  end

  depends_on "gcc" => :build # for gfortran
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "python@3.12" => [:build, :test]
  depends_on "python@3.13" => [:build, :test]
  depends_on "openblas"

  on_linux do
    depends_on "patchelf" => :build
  end

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
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
