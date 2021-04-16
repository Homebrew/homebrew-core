class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/82/a8/1e0f86ae3f13f7ce260e9f782764c16559917f24382c74edfb52149897de/numpy-1.20.2.zip"
  sha256 "878922bf5ad7550aa044aa9301d417e2d3ae50f0f577de92051d739ac6096cee"
  license "BSD-3-Clause"
  head "https://github.com/numpy/numpy.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "c2904e46fb22bc5d067c1c26deb07747f488721f734dce29d5cd049ce9684701"
    sha256 cellar: :any, big_sur:       "ae10cdd3dc05c9c76feef50b2ee8365b49b2c1b6efbe3e134d4390c4e82ed602"
    sha256 cellar: :any, catalina:      "e839ede282c17544b4905ad6c1c6cb89333ecf5ce15624bffeac153684e6497c"
    sha256 cellar: :any, mojave:        "877c88acd1d80ec7d5c4f6fe5fbe1f41b0d1f987ced4f7e4a5b968544ba7f17c"
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
