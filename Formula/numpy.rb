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
    sha256 cellar: :any, arm64_big_sur: "d653b20e1e60d22b4329777ff588cd243dc6a0c7322f4750598392b982701da5"
    sha256 cellar: :any, big_sur:       "c895ef9d14059a356a2dfae2ba5767c80b57c2d0870d3e49b237fd1fe74ed8bc"
    sha256 cellar: :any, catalina:      "1bcde495293cded6f3cb0842659e4b29da1f3a7b91fe4d33f9dc5e48477b2cbe"
    sha256 cellar: :any, mojave:        "8bfdca09abae9fb6d8a133f4b7ce2342e177ed4f50aab0cd6a78c32de1876038"
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
