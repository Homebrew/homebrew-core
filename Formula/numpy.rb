class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/82/a8/1e0f86ae3f13f7ce260e9f782764c16559917f24382c74edfb52149897de/numpy-1.20.2.zip"
  sha256 "878922bf5ad7550aa044aa9301d417e2d3ae50f0f577de92051d739ac6096cee"
  license "BSD-3-Clause"
  head "https://github.com/numpy/numpy.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "9279b94988655c47bdb9edc39b979aa5db413b20c5f3a779361ac4a7f9fa7e3c"
    sha256 cellar: :any, big_sur:       "2a6db741eeeb0bcc43abf0140035b2e1d5ffe5a9c56aefbd465113dce180afd1"
    sha256 cellar: :any, catalina:      "6ed8007be92b08b16ae5a7614628f58414772adbf7357fde99160023adffb15f"
    sha256 cellar: :any, mojave:        "cd3b07c7bbaca5aa08394c579440c0e2c691adfb53b055d319d1f54a69be6250"
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
