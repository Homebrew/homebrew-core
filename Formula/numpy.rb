class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/f3/1f/fe9459e39335e7d0e372b5e5dcd60f4381d3d1b42f0b9c8222102ff29ded/numpy-1.20.3.zip"
  sha256 "e55185e51b18d788e49fe8305fd73ef4470596b33fc2c1ceb304566b99c71a69"
  license "BSD-3-Clause"
  head "https://github.com/numpy/numpy.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "dd4a72cbff9757f080f0f137208171dd58d8049e5a7adc16ca282d96ebf28608"
    sha256 cellar: :any, big_sur:       "a5136e68ef782cbd9bd33be566445a3786b0d6ea474fd916362024753642793b"
    sha256 cellar: :any, catalina:      "83191f3e14bcd4bdcc66e2ee19beefff2841e134c2acdc3379fef6a6ad5a3c42"
    sha256 cellar: :any, mojave:        "8454fcdd5d9c9df3c82e3056b721475a3ba737dd85300a8be9cb5034caedc212"
  end

  depends_on "cython" => :build
  depends_on "gcc" => :build # for gfortran
  depends_on "openblas"
  depends_on "python@3.9"

  fails_with gcc: "5"

  def install
    openblas = Formula["openblas"].opt_prefix
    ENV["ATLAS"] = "None" # avoid linking against Accelerate.framework
    ENV["BLAS"] = ENV["LAPACK"] = "#{openblas}/lib/#{shared_library("libopenblas")}"

    config = <<~EOS
      [openblas]
      libraries = openblas
      library_dirs = #{openblas}/lib
      include_dirs = #{openblas}/include
    EOS

    Pathname("site.cfg").write config

    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    ENV.prepend_create_path "PYTHONPATH", Formula["cython"].opt_libexec/"lib/python#{xy}/site-packages"

    system Formula["python@3.9"].opt_bin/"python3", "setup.py", "build",
        "--fcompiler=gfortran", "--parallel=#{ENV.make_jobs}"
    system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(prefix)
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
