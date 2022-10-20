class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/64/8e/9929b64e146d240507edaac2185cd5516f00b133be5b39250d253be25a64/numpy-1.23.4.tar.gz"
  sha256 "ed2cc92af0efad20198638c69bb0fc2870a58dabfba6eb722c933b48556c686c"
  license "BSD-3-Clause"
  head "https://github.com/numpy/numpy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "603a58d48cc7266d3c34d67a8506059a06866fe0c4f062eb53639dcec95743f9"
    sha256 cellar: :any,                 arm64_big_sur:  "2e7e1d3cb83db765080b7e385facb3df494b199aa3f97f137883c4c865d577bc"
    sha256 cellar: :any,                 monterey:       "a18cfc89e94eb7e00267c2926f82c64647bb380f14dca758c3a820374c0cdf60"
    sha256 cellar: :any,                 big_sur:        "76be1a4d1db330c71778190da1f0ac99369567f9ce440c2f99cbe14f0383823b"
    sha256 cellar: :any,                 catalina:       "2440b6c930bcfa6d0892c8386eb4eff01a1b256c1567e60b25408f40c1c49280"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17cbaada1e238bc50767e7a61a9f27472c6d9308b0b596a86127965ac4171d9d"
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
