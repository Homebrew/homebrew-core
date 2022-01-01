class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/50/e1/9b0c184f04b8cf5f3c941ffa56fbcbe936888bdac9aa7ba6bae405ac752b/numpy-1.22.0.zip"
  sha256 "a955e4128ac36797aaffd49ab44ec74a71c11d6938df83b1285492d277db5397"
  license "BSD-3-Clause"
  head "https://github.com/numpy/numpy.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_monterey: "92f6b5f147bd1295ab1d64bba9451a251c6326607d53c8e9a62c3895f0523ffb"
    sha256 cellar: :any, arm64_big_sur:  "659651fbcb92c17f4466787747055774cc27fac0236e0fb718969a19bf005513"
    sha256 cellar: :any, monterey:       "6eb881aed76b7ef92b369a5bf4999adb3e5028b75d29e379663d7de64b337bb4"
    sha256 cellar: :any, big_sur:        "dc648aa1b370d08c950d423ec8de4276de0ffaf0af65ebd8fc3b1aa0e3919f37"
    sha256 cellar: :any, catalina:       "9085bbdc6b07cb35083ad8d21eb8d7f2329e985809e016b38f5943939490e80e"
    sha256               x86_64_linux:   "a4bce872c432d8db7d0277f6c5c6f97a61b828408110ab17ee298eb0bf8901f9"
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
