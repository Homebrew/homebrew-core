class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/d2/48/f445be426ccd9b2fb64155ac6730c7212358882e589cd3717477d739d9ff/numpy-1.20.1.zip"
  sha256 "3bc63486a870294683980d76ec1e3efc786295ae00128f9ea38e2c6e74d5a60a"
  license "BSD-3-Clause"
  head "https://github.com/numpy/numpy.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "f6a3d8b3a6e12cdf9860294cd51e21dc768c693575dcece33194acac5ae9e850"
    sha256 cellar: :any, big_sur:       "1b118062f2a8ac2e5afd49837bac5f1f94d316893f046cfd395fa942ef175231"
    sha256 cellar: :any, catalina:      "a85ea3768ec1065e7b65b40c4f150b444502d572ddc5bac99f23a19d9416b17f"
    sha256 cellar: :any, mojave:        "cf62fa86e5ada65ee6400159c45d5ab7dec3f5bed40c20f6b94c1dbcd886a0ae"
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
