class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/03/c6/14a17e10813b8db20d1e800ff9a3a898e65d25f2b0e9d6a94616f1e3362c/numpy-1.23.0.tar.gz"
  sha256 "bd3fa4fe2e38533d5336e1272fc4e765cabbbde144309ccee8675509d5cd7b05"
  license "BSD-3-Clause"
  head "https://github.com/numpy/numpy.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_monterey: "cf51179a9152c39d2036ea6e2a9c33944a0b9e1a55a09c8999a6bd94bcfed325"
    sha256 cellar: :any, arm64_big_sur:  "d10b0ebafde43e574c09aa377894e15b3066cce4f8cf1e9a2d7ea122c4b58b01"
    sha256 cellar: :any, monterey:       "abeabecda36dd3e21eec469dd11baa33fec2427def0faa2d1ea54e95bf3179cb"
    sha256 cellar: :any, big_sur:        "82485cee2333f0a058edb9a21d0d34da0cb0c05248804154a6c0c174b5227cc5"
    sha256 cellar: :any, catalina:       "2d14cb676b8fae55b1ae99e7771bc9a357bf2ad9fa841d531070909abfec0966"
    sha256               x86_64_linux:   "04afd4efc8ba957e6bad7dfb1f56015460d4a7b6188aa196d652679e629c346b"
  end

  depends_on "gcc" => :build # for gfortran
  depends_on "libcython" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.9" => [:build, :test]
  depends_on "openblas"

  fails_with gcc: "5"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/python@\d\.\d+/) }
        .map(&:opt_bin)
        .map { |bin| bin/"python3" }
  end

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

    pythons.each do |python|
      xy = Language::Python.major_minor_version python
      ENV.prepend_create_path "PYTHONPATH", Formula["libcython"].opt_libexec/"lib/python#{xy}/site-packages"

      system python, "setup.py", "build",
             "--fcompiler=#{Formula["gcc"].opt_bin}/gfortran", "--parallel=#{ENV.make_jobs}"
      system python, *Language::Python.setup_install_args(prefix),
                     "--install-lib=#{prefix/Language::Python.site_packages(python)}"
    end
  end

  test do
    pythons.each do |python|
      system python, "-c", <<~EOS
        import numpy as np
        t = np.ones((3,3), int)
        assert t.sum() == 9
        assert np.dot(t, t).sum() == 27
      EOS
    end
  end
end
