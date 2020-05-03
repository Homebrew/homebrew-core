class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/2d/f3/795e50e3ea2dc7bc9d1a2eeea9997d5dce63b801e08dfc37c2efce341977/numpy-1.18.4.zip"
  sha256 "bbcc85aaf4cd84ba057decaead058f43191cc0e30d6bc5d44fe336dc3d3f4509"
  head "https://github.com/numpy/numpy.git"

  bottle do
    cellar :any
    sha256 "14f3fe23e77f0ea3ff28f5b339bbcccfe8c8b8c60456eb03bc9bd7d51ca031f5" => :catalina
    sha256 "4aabd9a93b951b151ff2d8be7a07e31b6370685032f694b5a4a800803d1e6c1d" => :mojave
    sha256 "f866629bdf3582ae8441df9b1522102f5adb26a1860ae2af0ece499ab8edfc04" => :high_sierra
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
