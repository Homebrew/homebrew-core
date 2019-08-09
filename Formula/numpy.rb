class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/cb/79/96df883cd6df0c86cb010e6f4ff790b7a30a45016a9509c94ea72c8695cd/numpy-1.17.1.zip"
  sha256 "f11331530f0eff69a758d62c2461cd98cdc2eae0147279d8fc86e0464eb7e8ca"
  head "https://github.com/numpy/numpy.git"

  bottle do
    cellar :any
    sha256 "9b0ab97c7291ed10e03b005b99e14e60811813d9df12afc5cd4d4dd2c6d517d3" => :catalina
    sha256 "e6af9a8f03fb67d55fa2fed5269f9366a5b785214cbaf5a73656e005990512c8" => :mojave
    sha256 "9e18f3301244f2cc3ca941c202e402bb68abc350de91908c3189bd134593c9b2" => :high_sierra
    sha256 "cf613a9b5dc6bada1ed950b242283a9faf6c215b50a15e007047d13e26379ead" => :sierra
  end

  depends_on "cython" => :build
  depends_on "gcc" => :build # for gfortran
  depends_on "openblas"
  depends_on "python"

  def install
    openblas = Formula["openblas"].opt_prefix
    ENV["ATLAS"] = "None" # avoid linking against Accelerate.framework
    ENV["BLAS"] = ENV["LAPACK"] = "#{openblas}/lib/libopenblas.dylib"

    config = <<~EOS
      [openblas]
      libraries = openblas
      library_dirs = #{openblas}/lib
      include_dirs = #{openblas}/include
    EOS

    Pathname("site.cfg").write config

    version = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", Formula["cython"].opt_libexec/"lib/python#{version}/site-packages"

    system "python3", "setup.py",
      "build", "--fcompiler=gnu95", "--parallel=#{ENV.make_jobs}",
      "install", "--prefix=#{prefix}",
      "--single-version-externally-managed", "--record=installed.txt"
  end

  test do
    system "python3", "-c", <<~EOS
      import numpy as np
      t = np.ones((3,3), int)
      assert t.sum() == 9
      assert np.dot(t, t).sum() == 27
    EOS
  end
end
