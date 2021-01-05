class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/51/60/3f0fe5b7675a461d96b9d6729beecd3532565743278a9c3fe6dd09697fa7/numpy-1.19.5.zip"
  sha256 "a76f502430dd98d7546e1ea2250a7360c065a5fdea52b2dffe8ae7180909b6f4"
  license "BSD-3-Clause"
  head "https://github.com/numpy/numpy.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "fb2e87332b99e24056b915e28a78e17a33c1a13547e2cc144760646421aee01d" => :big_sur
    sha256 "a32c273bf47a9304a415ea8c58b801e255eb69f3fbc1c3054c03ecdba0e0da13" => :arm64_big_sur
    sha256 "ed781d5ce1f7c7a8495860b27b577cc83fd4eb056ad2f7f2c630a17141ccd0e8" => :catalina
    sha256 "3ccaa0bf93bbc235d04af89c2777252e7655f6b4ddcef09b4fb100f28b2a5cc1" => :mojave
  end

  depends_on "cython" => :build
  depends_on "gcc" => :build # for gfortran
  depends_on "openblas"
  depends_on "python@3.9"

  # Upstream fix for Apple Silicon, remove in next version
  # https://github.com/numpy/numpy/pull/17906
  patch do
    url "https://github.com/numpy/numpy/commit/1ccb4c6d.patch?full_index=1"
    sha256 "7777fa6691d4f5a8332538b634d4327313e9cf244bb2bbc25c64acfb64c92602"
  end

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
