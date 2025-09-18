class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/d0/19/95b3d357407220ed24c139018d2518fab0a61a948e68286a25f1a4d049ff/numpy-2.3.3.tar.gz"
  sha256 "ddc7c39727ba62b80dfdbedf400d1c10ddfa8eefbd7ec8dcb118be8b56d31029"
  license "BSD-3-Clause"
  head "https://github.com/numpy/numpy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "34486a338bb0be9730e5d86c0fef88f09378b32a346950e7fc2c99c8e29145ce"
    sha256 cellar: :any,                 arm64_sequoia: "4c5c3288b6340ee47adf7d0c261fc2a3cf48fd8aaadac19dcb220477d44fb3b3"
    sha256 cellar: :any,                 arm64_sonoma:  "4e77b5fee2c35785f79e036498fd302cddda064b761ea8f927a1b5cd0a9af5e1"
    sha256 cellar: :any,                 arm64_ventura: "72a6859ee346933bff1be44e0516f49ad19d98cde6334ca5b21180849ff37b94"
    sha256 cellar: :any,                 sonoma:        "71d38e4ce2299196809913096c37b4405985c24e86d53950c8a32f4dc2abb842"
    sha256 cellar: :any,                 ventura:       "08c53ea7ee93c3e26d1388b700a02b7cfa078c13e4b0c786369ca3a9d731d56f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6595481da48da5db8aba33019e08fd45886f9f76323b9486a5df660e0d5d30a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "644a7ef1fce081d82b765c3714e69178b5ca101fdc1924c367ff4a87a46e022f"
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
