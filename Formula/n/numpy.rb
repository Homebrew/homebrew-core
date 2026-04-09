class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/d7/9f/b8cef5bffa569759033adda9481211426f12f53299629b410340795c2514/numpy-2.4.4.tar.gz"
  sha256 "2d390634c5182175533585cc89f3608a4682ccb173cc9bb940b2881c8d6f8fa0"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/numpy/numpy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "be8d5455306e7f5fdb99389f294b27931619709b860b99eebe4081fd93182c29"
    sha256 cellar: :any,                 arm64_sequoia: "fbc825e7914d96603c41da9d567c0068fc2769249abe48b7936ce216b2a97baf"
    sha256 cellar: :any,                 arm64_sonoma:  "001fd5c3dd469e473a279d1f7e2d17fb2917512f59c2ccf0932d1250f96df632"
    sha256 cellar: :any,                 sonoma:        "814d0990e82df04f14ad08eef9f9cc1af297c9f2078ba8d2739695c47a9b92c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0d8c959d20e42ba02ab757b01a8075e3cec612ee4be94ea5392036088e996ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70a65fa1c64e25046bb4772ee33bfed9e770595ab4660c44bd6ab93ecc5a707b"
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
