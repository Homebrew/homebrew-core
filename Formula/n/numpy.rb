class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/22/fd/89965aa4ac08c74998539fcbf24fa3540f3e15237fbeb6bcf9c908f4aade/numpy-2.5.1.tar.gz"
  sha256 "a48a113e6afea91f5608793bafa7ef2ad481fefbda87ec5069f483de61cb9fa3"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/numpy/numpy.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fd397e8d9e98c3bd7f75994543a8567f635f492f732cbee630404b9f335344e5"
    sha256 cellar: :any, arm64_sequoia: "c410161b79017a5273505bd9cd8088dd3b50364fd69872a4d53b073c8edeeb92"
    sha256 cellar: :any, arm64_sonoma:  "74a95dbd9b93523b858a9e86ddc6c1c216722cbd62cbbc55ad349fb0edecbbe0"
    sha256 cellar: :any, sonoma:        "19c7e494cb6fbe2dfdbe2e07e9e0c914d07b7bb2f23fce30f4fd2483453e2756"
    sha256 cellar: :any, arm64_linux:   "de64260d36d1ec57fe98842deffd3a3e2f5330b3d0ca19c00d447496f1e171e7"
    sha256 cellar: :any, x86_64_linux:  "564351f76a996cdc01176722be53f562ab1cb6724128cf13fd31784bb4d1614f"
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
