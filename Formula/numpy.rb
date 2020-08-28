class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/2c/2f/7b4d0b639a42636362827e611cfeba67975ec875ae036dd846d459d52652/numpy-1.19.1.zip"
  sha256 "b8456987b637232602ceb4d663cb34106f7eb780e247d51a260b84760fd8f491"
  license "BSD-3-Clause"
  head "https://github.com/numpy/numpy.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "c457ff1ee5e3adf4c11c628aad45276db5bfd9cc18d245f8346ea9ed28d676a7" => :catalina
    sha256 "d44b16635bfcfebe1f515adf6533123fcf7f5a5f087922b78fad79a154b0a8e8" => :mojave
    sha256 "1c66b47dbddc55d6d93ef42fe08f0a26b47ab6fe0d3d66024ee88db4634a26ad" => :high_sierra
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
