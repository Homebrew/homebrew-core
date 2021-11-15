class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/fb/48/b0708ebd7718a8933f0d3937513ef8ef2f4f04529f1f66ca86d873043921/numpy-1.21.4.zip"
  sha256 "e6c76a87633aa3fa16614b61ccedfae45b91df2767cf097aa9c933932a7ed1e0"
  license "BSD-3-Clause"
  head "https://github.com/numpy/numpy.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "b0553e85982be6edaf90a71dc7561ab64f096188fcc7142dc535602732dc0cfc"
    sha256 cellar: :any, monterey:      "14dc6f3429ade704765c7f23553b7b7b60ad389ae8348224eb16683408530783"
    sha256 cellar: :any, big_sur:       "599eac2a70e5c48c9f4fdcf5960eb5165a929f6028cdf641ee1b2f3df019faf2"
    sha256 cellar: :any, catalina:      "3281f550910f6b4d1b3accf5b1fbd2f08bb1d1eb42b2a424f286d09f8d8ee694"
    sha256               x86_64_linux:  "1787c0a7ce1c2f89550d9a97b9cbea0f305915e93884f6978b36686ada4c7a60"
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
