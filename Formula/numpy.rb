class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/c3/97/fd507e48f8c7cab73a9f002e52e15983b5636b4ac6cf69b83ae240324b44/numpy-1.20.0.zip"
  sha256 "3d8233c03f116d068d5365fed4477f2947c7229582dad81e5953088989294cec"
  license "BSD-3-Clause"
  head "https://github.com/numpy/numpy.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "7cb95a573088edce3373802ba84005c2bc461dcb098f94b15320a9a32db42a25" => :big_sur
    sha256 "eae47ff8333fc9d0c5364ce6d71300ad5bd57cafbe5b124b0bf13a318f562774" => :arm64_big_sur
    sha256 "1d336f68b7bfacfbd57e3b348ffacdb842e418ba219914549547982c2765d949" => :catalina
    sha256 "bc985b0768c1c33db763b1b9d181f960509bda57a7c6cb58605b54ac0df93d3a" => :mojave
  end

  depends_on "cython" => :build
  depends_on "gcc" => :build # for gfortran
  depends_on "openblas"
  depends_on "python@3.9"

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

    version = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    ENV.prepend_create_path "PYTHONPATH", Formula["cython"].opt_libexec/"lib/python#{version}/site-packages"

    system Formula["python@3.9"].opt_bin/"python3", "setup.py",
      "build", "--fcompiler=gnu95", "--parallel=#{ENV.make_jobs}",
      "install", "--prefix=#{prefix}",
      "--single-version-externally-managed", "--record=installed.txt"
  end

  test do
    system Formula["python@3.9"].opt_bin/"python3", "-c", <<~EOS
      import numpy as np
      t = np.ones((3,3), int)
      assert t.sum() == 9
      assert np.dot(t, t).sum() == 27
    EOS
  end
end
