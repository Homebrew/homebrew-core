class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/2e/19/d7c972dfe90a353dbd3efbbe1d14a5951de80c99c9dc1b93cd998d51dc0f/numpy-2.3.1.tar.gz"
  sha256 "1ec9ae20a4226da374362cca3c62cd753faf2f951440b0e3b98e93c235441d2b"
  license "BSD-3-Clause"
  head "https://github.com/numpy/numpy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b1f3ac9d59ade153b11e5d275615324f7395c552649a6285b81e40f681d05481"
    sha256 cellar: :any,                 arm64_sonoma:  "ee58cfffab4badcd67083a8d715ea6b35fd4b503a211822bf82b3195b85e874c"
    sha256 cellar: :any,                 arm64_ventura: "47e048460edacf0c02839d7106fdf36bffa16a801391bfc5ee6ead4eea0aa4ca"
    sha256 cellar: :any,                 sonoma:        "13868cfaa70a68dfca5dbbb34818bfbd9d075149716e95657fabc572f0707cd2"
    sha256 cellar: :any,                 ventura:       "d3d9d0fbf1cb8dba37da1ad95e23fb540096c750c8f439c2b3192fc649e03252"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01e587dcc7af05b5ec6d5133fa43e69bf4992567d6deb72866d31fe7a01549b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35730de24e498e410c6fb786be0462c12c8ca11b18f28d606712e3efe591e50d"
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
