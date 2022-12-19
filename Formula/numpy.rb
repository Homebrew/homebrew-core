class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/5f/c7/5ca7c100dcc85b5ef1b176bdf87be5e4392c2c3018e13cc7cdef828c6a09/numpy-1.24.0.tar.gz"
  sha256 "c4ab7c9711fe6b235e86487ca74c1b092a6dd59a3cb45b63241ea0a148501853"
  license "BSD-3-Clause"
  head "https://github.com/numpy/numpy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "42d0612e7a303db93173338f8c6427b7ba287b9b1401cef64e20c778f50898e9"
    sha256 cellar: :any,                 arm64_monterey: "0ecd3124146d911a9445fbb1da7465ea88d29a5402cc8e8ebc9da6205f91d070"
    sha256 cellar: :any,                 arm64_big_sur:  "c2d13e032774ce3d8c9303fb5b370b167b42e0f84db616952d2c54c452f8d981"
    sha256 cellar: :any,                 ventura:        "64e324362bff60f9c9fa643dcbfb34bebdab029b5c8ef2774c8207591b0fa0c4"
    sha256 cellar: :any,                 monterey:       "238f9537081d326725b4ae8b3558fa9d0522a7657089e5ace04f49edfc2d06cb"
    sha256 cellar: :any,                 big_sur:        "60098a279a6e9d2efbe7068c53e343a0eacdb0d3cf6910f51060f3df05cdf333"
    sha256 cellar: :any,                 catalina:       "ce22b454a56f09a724ea33277b8981bd1256bdbf7614f8fdeffe0c2cc2b7d3c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e09fde42d2bf54dd3f3b6af1222b7358c1dd51b7f59cec6d322af6cb0a024e38"
  end

  depends_on "gcc" => :build # for gfortran
  depends_on "libcython" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "openblas"

  fails_with gcc: "5"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .sort_by(&:version) # so that `bin/f2py` and `bin/f2py3` use python3.10
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    openblas = Formula["openblas"]
    ENV["ATLAS"] = "None" # avoid linking against Accelerate.framework
    ENV["BLAS"] = ENV["LAPACK"] = openblas.opt_lib/shared_library("libopenblas")

    config = <<~EOS
      [openblas]
      libraries = openblas
      library_dirs = #{openblas.opt_lib}
      include_dirs = #{openblas.opt_include}
    EOS

    Pathname("site.cfg").write config

    pythons.each do |python|
      site_packages = Language::Python.site_packages(python)
      ENV.prepend_path "PYTHONPATH", Formula["libcython"].opt_libexec/site_packages

      system python, "setup.py", "build", "--fcompiler=#{Formula["gcc"].opt_bin}/gfortran",
                                          "--parallel=#{ENV.make_jobs}"
      system python, *Language::Python.setup_install_args(prefix, python)
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
