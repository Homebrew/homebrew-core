class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/c5/63/a48648ebc57711348420670bb074998f79828291f68aebfff1642be212ec/numpy-1.19.4.zip"
  sha256 "141ec3a3300ab89c7f2b0775289954d193cc8edb621ea05f99db9cb181530512"
  license "BSD-3-Clause"
  head "https://github.com/numpy/numpy.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "f6dbc841d3108a7b3f0f7024ff238604c8e05173492cc3d3b27f6a961d5fbf27" => :catalina
    sha256 "469537da2e3051db86697d324e7fd29d9807393a9d6d7dc0cd9d9db92ae6c75e" => :mojave
    sha256 "b1c2160ec27e97fd39c5dbd4d72bf287b2f742f1477c4557694bfb9128fe4d2e" => :high_sierra
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
