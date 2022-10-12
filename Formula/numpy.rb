class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/64/8e/9929b64e146d240507edaac2185cd5516f00b133be5b39250d253be25a64/numpy-1.23.4.tar.gz"
  sha256 "ed2cc92af0efad20198638c69bb0fc2870a58dabfba6eb722c933b48556c686c"
  license "BSD-3-Clause"
  head "https://github.com/numpy/numpy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c06723f9503fb13bc99fb93484c6bb8d8d1b3e58925bcd282eb0cf0c2ecbb213"
    sha256 cellar: :any,                 arm64_big_sur:  "e18dcfbb2642554f55e128fbaba2b3af7ed6e678ee314b13a600ce7ea55521b3"
    sha256 cellar: :any,                 monterey:       "61764d9c8dde4748145f24cb54365c65c7d1f74f526f69c161dd7a8200e75738"
    sha256 cellar: :any,                 big_sur:        "32c5e7b3f1976f99bbdefb2b8a859f3f8bda217ca69aaab9c9cb3a76e4f542ae"
    sha256 cellar: :any,                 catalina:       "b78aafcc4039ebbbc402154192f37f296ef9d720909741bbea6012dc5608c713"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b76cbcfb54dc293f60a453dbf43c71e90205d2341820690c63eb8718a6ecc058"
  end

  depends_on "gcc" => :build # for gfortran
  depends_on "libcython" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.9" => [:build, :test]
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
