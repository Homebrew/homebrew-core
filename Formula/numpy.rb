class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/01/1b/d3ddcabd5817be02df0e6ee20d64f77ff6d0d97f83b77f65e98c8a651981/numpy-1.18.5.zip"
  sha256 "34e96e9dae65c4839bd80012023aadd6ee2ccb73ce7fdf3074c62f301e63120b"
  head "https://github.com/numpy/numpy.git"

  bottle do
    cellar :any
    sha256 "f8ac2bb9f1f9fed629b3cb3320478bd74ecafa3c7440f1f2d188a4f1fe7c43e6" => :catalina
    sha256 "21cfc3c6bd6850ba4aabd038400d59f6f594a29994e648934234bba60a158f75" => :mojave
    sha256 "e7242e0c0ed7209b544611b5af9cc5c615c20e3b9e3b80b963bff966ae69d8c5" => :high_sierra
  end

  depends_on "cython" => :build
  depends_on "gcc" => :build # for gfortran
  depends_on "openblas"
  depends_on "python@3.8"

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

    version = Language::Python.major_minor_version Formula["python@3.8"].opt_bin/"python3"
    ENV.prepend_create_path "PYTHONPATH", Formula["cython"].opt_libexec/"lib/python#{version}/site-packages"

    system Formula["python@3.8"].opt_bin/"python3", "setup.py",
      "build", "--fcompiler=gnu95", "--parallel=#{ENV.make_jobs}",
      "install", "--prefix=#{prefix}",
      "--single-version-externally-managed", "--record=installed.txt"
  end

  test do
    system Formula["python@3.8"].opt_bin/"python3", "-c", <<~EOS
      import numpy as np
      t = np.ones((3,3), int)
      assert t.sum() == 9
      assert np.dot(t, t).sum() == 27
    EOS
  end
end
