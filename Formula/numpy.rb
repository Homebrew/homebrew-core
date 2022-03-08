class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/64/4a/b008d1f8a7b9f5206ecf70a53f84e654707e7616a771d84c05151a4713e9/numpy-1.22.3.zip"
  sha256 "dbc7601a3b7472d559dc7b933b18b4b66f9aa7452c120e87dfb33d02008c8a18"
  license "BSD-3-Clause"
  head "https://github.com/numpy/numpy.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_monterey: "f6c33f792d8c00665cfe271ec3b9eae946ee5106fa79a2225490653ef810359c"
    sha256 cellar: :any, arm64_big_sur:  "96abb2b50960b5bb1c5735bfa75e364198edecfbf8394ff09efb385bce9133e9"
    sha256 cellar: :any, monterey:       "6a8ee1c9062d547a38e56a1625f355cd211b3e35ac8f388f31f21b91b8798ce1"
    sha256 cellar: :any, big_sur:        "1646cf4cb750986f240fff736000a512d9fc0d8d347a1d7a1622fd3c51829698"
    sha256 cellar: :any, catalina:       "ce4cbd7a3bf888994c804cf2ac0df6ec43cd52973c6ca32f23dcf3234d63d7e3"
    sha256               x86_64_linux:   "cfc7ee6231a35c689271532272c30e60dcbf4d86fa8d65e5b7a2dac3e67bdad5"
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
    ENV.prepend_path "PYTHONPATH", buildpath/"temp/lib/python#{xy}/site-packages"
    resources.each do |r|
      r.stage do
        system "python3", *Language::Python.setup_install_args(buildpath/"temp")
      end
    end

    system Formula["python@3.9"].opt_bin/"python3", "setup.py", "build",
        "--fcompiler=#{Formula["gcc"].opt_bin}/gfortran", "--parallel=#{ENV.make_jobs}"
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
