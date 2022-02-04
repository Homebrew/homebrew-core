class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/e9/6c/c0a8130fe198f27bab92f1b28631e0cc2572295f6b7a31e87efe7448aa1c/numpy-1.22.2.zip"
  sha256 "076aee5a3763d41da6bef9565fdf3cb987606f567cd8b104aded2b38b7b47abf"
  license "BSD-3-Clause"
  head "https://github.com/numpy/numpy.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_monterey: "ec687b611e05ca93ddb4dbd2a01dda7c43ea12f01a960a5731572ff10fce725e"
    sha256 cellar: :any, arm64_big_sur:  "9b17b2232e7e42e71e2714d1ce37ec22f513ed0a5e4f95ced2964824da0f5fa5"
    sha256 cellar: :any, monterey:       "4d5b0075ca2f4a97486636eec705114b351e7c0340eaa84480a0f948e2e67a4b"
    sha256 cellar: :any, big_sur:        "c23e04d40a92a4f210d2285dffc5210ec651ed6bba6dc0d4ca1ce2c8967e6bd6"
    sha256 cellar: :any, catalina:       "654c3c4fc4b66b1d986c31f1ef7dd27c57fa8b23d1fbcfad04b71a2a9ec22881"
    sha256               x86_64_linux:   "ce36de6c56b8085ce0f9c796eedbe054759a6696f07c384162889e5ba5340d14"
  end

  depends_on "cython" => :build
  depends_on "gcc" => :build # for gfortran
  depends_on "openblas"
  depends_on "python@3.9"

  fails_with gcc: "5"

  # numpy requires setuptools < 60.0
  # https://github.com/numpy/numpy/issues/20824
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
