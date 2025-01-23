class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/ec/d0/c12ddfd3a02274be06ffc71f3efc6d0e457b0409c4481596881e748cb264/numpy-2.2.2.tar.gz"
  sha256 "ed6906f61834d687738d25988ae117683705636936cc605be0bb208b23df4d8f"
  license "BSD-3-Clause"
  head "https://github.com/numpy/numpy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "15cf20d0aea78106ce25189c48fc7357887d90b95412b05ffa13145a2d775267"
    sha256 cellar: :any,                 arm64_sonoma:  "e3c171aedb059d07be9c03336bf5feb7d562cac774e98e0c52a8d908ff5ae36d"
    sha256 cellar: :any,                 arm64_ventura: "ad8a60a698802fa51e254e8286cf6e0200bc63376b5f042f300b78e8be6496ad"
    sha256 cellar: :any,                 sonoma:        "9eb098ae8e2808998f84e9fd6243dc2971fed01b00bb7d9dbefbfd24c4cf8cea"
    sha256 cellar: :any,                 ventura:       "1a18d737886399ef77c1e6890cc81e055eb21c26c5eae66dab23d7fda1c700d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1157d96cf7f66bad29a97665daa35db303b174543579c270f9dad6637e2492b6"
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
