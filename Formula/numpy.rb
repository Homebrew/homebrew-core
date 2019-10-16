class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/ac/36/325b27ef698684c38b1fe2e546e2e7ef9cecd7037bcdb35c87efec4356af/numpy-1.17.2.zip"
  sha256 "73615d3edc84dd7c4aeb212fa3748fb83217e00d201875a47327f55363cef2df"
  head "https://github.com/numpy/numpy.git"

  bottle do
    cellar :any
    sha256 "57882a3c9d8dee105a51dae79abbd1408161f9bef2f62ee44499579ec98fb88a" => :catalina
    sha256 "9c7bcdd3f775b37d617656efb573ae71452951b3bf4ab7a38cd236af0f853c44" => :mojave
    sha256 "210cf09703843cfc175379ad44188cdf66ba66ed23bd368c16b8482a45bf948f" => :high_sierra
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
