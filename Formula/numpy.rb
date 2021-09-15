class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/3a/be/650f9c091ef71cb01d735775d554e068752d3ff63d7943b26316dc401749/numpy-1.21.2.zip"
  sha256 "423216d8afc5923b15df86037c6053bf030d15cc9e3224206ef868c2d63dd6dc"
  license "BSD-3-Clause"
  head "https://github.com/numpy/numpy.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "f500dc16bc97e85df8944d6542ba05c94d2c23c22fb427d5295925cd81edac8f"
    sha256 cellar: :any, big_sur:       "12fd9c0abc522f3dd2196f599ebae42a5d8651268007e0ec7839b48d71f1f665"
    sha256 cellar: :any, catalina:      "2f3dde5cf8bf319738b7b9cbac3d73ae5a87653c3931bb8bd187b825f6760921"
    sha256 cellar: :any, mojave:        "ec8ecebf33cae503741d0ed5690dbac8823dfb0c223b168bd3f3e054cd625ad0"
    sha256               x86_64_linux:  "e6c64515ea9d22ed0e15d5f40bdf13335fff038ba0e63d735fc0c6d39389d1c2"
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
