class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/f1/2c/717bdd12404c73ec0c8c734c81a0bad7048866bc36a88a1b69fd52b01c07/numpy-1.19.0.zip"
  sha256 "76766cc80d6128750075378d3bb7812cf146415bd29b588616f72c943c00d598"
  license "BSD-3-Clause"
  head "https://github.com/numpy/numpy.git"

  bottle do
    cellar :any
    sha256 "fa9c808a7473eac7f9366142edf410530792f0b7491fcb0035b05e6e9bfe19d1" => :catalina
    sha256 "2caa9558fe1122f529c3bc6a88eff97fc1b76ab53c7c45997adb7d08c7c8042b" => :mojave
    sha256 "e6ca79c3ca935316f3ec4c55572ac93baf1f0d73cb83e81df7c1cbc93eb9fa85" => :high_sierra
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
