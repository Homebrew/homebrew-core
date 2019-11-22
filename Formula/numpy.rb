class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/ff/59/d3f6d46aa1fd220d020bdd61e76ca51f6548c6ad6d24ddb614f4037cf49d/numpy-1.17.4.zip"
  sha256 "f58913e9227400f1395c7b800503ebfdb0772f1c33ff8cb4d6451c06cabdf316"
  head "https://github.com/numpy/numpy.git"

  bottle do
    cellar :any
    sha256 "7b63631ab91df782aafe5662d11ad15265ff55ddd23647484ea51566e77e4ca1" => :catalina
    sha256 "0c7b145b0075974fbb3beb4bef585b6c352d71ec470aeb2f3d6c2388c3073f25" => :mojave
    sha256 "93d3b0d26275214bdd1d359c29e323b7719ac16269dbc98db3b5d80c7dfa8520" => :high_sierra
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
