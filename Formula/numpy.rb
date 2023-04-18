class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/e4/a9/6704bb5e1d1d778d3a6ee1278a8d8134f0db160e09d52863a24edb58eab5/numpy-1.24.2.tar.gz"
  sha256 "003a9f530e880cb2cd177cba1af7220b9aa42def9c4afc2a2fc3ee6be7eb2b22"
  license "BSD-3-Clause"
  head "https://github.com/numpy/numpy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "885f55ca8b1a88627292e16656ba6396d587830f3919ce9d7f66969ba34c294c"
    sha256 cellar: :any,                 arm64_monterey: "0a96f47ed28398f80358edc4738833fd7710d2aa19b9902d31e368f8a87dcd07"
    sha256 cellar: :any,                 arm64_big_sur:  "92bc7c4390bf719678c935ca2fbfac0294a51bddfa49850f8aa751fe21515f8c"
    sha256 cellar: :any,                 ventura:        "686a94aeb73f80d8fc4c4d61b8f25e22880217ff64b29904583e41046b3e51c9"
    sha256 cellar: :any,                 monterey:       "a014fbb0dd176d9f2798e8c82458086049511150c6e7c86b58a88236f56b4425"
    sha256 cellar: :any,                 big_sur:        "cd9640c3aa8ff5f93d7cf7ee56b85efc8e46d9585094dbec8100143b79fde0cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a6218d38684599df183c3915cd4435c231764c0d0d80895a8c6c80401ee17f8"
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
