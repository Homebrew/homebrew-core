class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/5f/d6/ad58ded26556eaeaa8c971e08b6466f17c4ac4d786cd3d800e26ce59cc01/numpy-1.21.3.zip"
  sha256 "63571bb7897a584ca3249c86dd01c10bcb5fe4296e3568b2e9c1a55356b6410e"
  license "BSD-3-Clause"
  head "https://github.com/numpy/numpy.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "b9beebd92ea4ed2621d6feac52863cd343aacde42f80fd523298930883d50b0a"
    sha256 cellar: :any, monterey:      "83ca2f027a51eb73aaa65e9faed22806fd77d659300a220ad2f7fa451b03ceec"
    sha256 cellar: :any, big_sur:       "1a3a0dcd161c260e7becfb8a64a0cc82ca1bb729ee3497a998e4c999788c7fad"
    sha256 cellar: :any, catalina:      "aa429d1d8cff5b9aa1172d724dbf8d7adb8a2193111e1599bbbfb546c043cfc0"
    sha256               x86_64_linux:  "1cc589b53301fafaedaa48b49a9824c52f2461bd511aa971c9006bb502f0ceb0"
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
