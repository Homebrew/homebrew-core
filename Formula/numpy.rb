class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/84/1e/ff467ac56bfeaea51d4a2e72d315c1fe440b20192fea7e460f0f248acac8/numpy-1.18.2.zip"
  sha256 "e7894793e6e8540dbeac77c87b489e331947813511108ae097f1715c018b8f3d"
  head "https://github.com/numpy/numpy.git"

  bottle do
    cellar :any
    sha256 "5e945560014469559716fd164a3a1f97cba1a043b2debecc0b245753f89db1bb" => :catalina
    sha256 "98940218200aed652d613b7219f5d2efd721c7d3336f7f6ed8d94bf7c3b288b9" => :mojave
    sha256 "66bcb71749ace74ca3bd2e6168837fc59691b1469de53882d16d15b1a8c555d4" => :high_sierra
  end

  depends_on "cython" => :build
  depends_on "gcc" => :build # for gfortran
  depends_on "openblas"
  depends_on "python"

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

    version = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", Formula["cython"].opt_libexec/"lib/python#{version}/site-packages"

    system "python3", "setup.py",
      "build", "--fcompiler=gnu95", "--parallel=#{ENV.make_jobs}",
      "install", "--prefix=#{prefix}",
      "--single-version-externally-managed", "--record=installed.txt"
  end

  test do
    system "python3", "-c", <<~EOS
      import numpy as np
      t = np.ones((3,3), int)
      assert t.sum() == 9
      assert np.dot(t, t).sum() == 27
    EOS
  end
end
