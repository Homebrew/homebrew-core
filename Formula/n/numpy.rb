class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/24/62/ae72ff66c0f1fd959925b4c11f8c2dea61f47f6acaea75a08512cdfe3fed/numpy-2.4.1.tar.gz"
  sha256 "a1ceafc5042451a858231588a104093474c6a5c57dcc724841f5c888d237d690"
  license "BSD-3-Clause"
  head "https://github.com/numpy/numpy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1a11aeba485637c55587e68ead615a87b1874b3dff8a647176b3be46ba04cc59"
    sha256 cellar: :any,                 arm64_sequoia: "153ea8aec95d99e547f7a366afcda1e482ff4e5d624b3acff1ac50282a83cbc8"
    sha256 cellar: :any,                 arm64_sonoma:  "e13a0ac688f19184d9793a60ef8cd8d4b6e54f3caf5a56084ce32c96cbb4ca56"
    sha256 cellar: :any,                 sonoma:        "2c447bd4be05e63ee43101642f68beb56d4770b9a1e4ca99a353ac8d3a420bfb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31477e85ad95feffdf2f26d5ae60dcba07df0f305359d65c9589ac9f585569aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee0cf704701a54950689d13db6d72188d3258ce59bf5142605a6b18e51f2ffb7"
  end

  depends_on "gcc" => :build # for gfortran
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "python@3.13" => [:build, :test]
  depends_on "python@3.14" => [:build, :test]
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
