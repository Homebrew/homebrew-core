class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/84/1e/ff467ac56bfeaea51d4a2e72d315c1fe440b20192fea7e460f0f248acac8/numpy-1.18.2.zip"
  sha256 "e7894793e6e8540dbeac77c87b489e331947813511108ae097f1715c018b8f3d"
  revision 1
  head "https://github.com/numpy/numpy.git"

  bottle do
    cellar :any
    sha256 "ac367c0e044b615fd033907e5075e2273de26bb03ee9c43d2b8e81a6e9864761" => :catalina
    sha256 "eb140ae54aafbb5d391d98784bffbd055094c5b127fbe6b46cb2201d2291999a" => :mojave
    sha256 "3d63fcda6a6b129dc7d544cc1e7b1d82ce5b7378763bacc96296b58108ab41e3" => :high_sierra
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
