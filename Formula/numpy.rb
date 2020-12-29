class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/c5/63/a48648ebc57711348420670bb074998f79828291f68aebfff1642be212ec/numpy-1.19.4.zip"
  sha256 "141ec3a3300ab89c7f2b0775289954d193cc8edb621ea05f99db9cb181530512"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/numpy/numpy.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "980ff2b2a656a9bd8583d8ac53d79149db57c4e0ebc0787c7339ffff61196651" => :big_sur
    sha256 "12fa9cba958b6e32a78ac795469ba679dce6c8614e7fcd87a61a95de566feb00" => :arm64_big_sur
    sha256 "a9316c2fbc6289f359a8379f667d5c7db067f86c2be153d40cd400ab03fe83a5" => :catalina
    sha256 "a01c9eac38f92f3079f860dada4f49543cb40ecbc42a62f3adf022529fb990bc" => :mojave
    sha256 "5884958d5903b9a8e5b47a81f0dc9ad5435873b472d3709b6956998356c8c353" => :high_sierra
  end

  depends_on "cython" => :build
  depends_on "gcc" => :build # for gfortran
  depends_on "openblas"
  depends_on "python@3.9"

  # Upstream fix for Apple Silicon, remove in next version
  # https://github.com/numpy/numpy/pull/17906
  patch do
    url "https://github.com/numpy/numpy/commit/1ccb4c6d.patch?full_index=1"
    sha256 "7777fa6691d4f5a8332538b634d4327313e9cf244bb2bbc25c64acfb64c92602"
  end

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
