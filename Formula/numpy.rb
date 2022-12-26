class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/ce/b8/c170db50ec49d5845bd771bc5549fe734ee73083c5c52791915f95d8e2bc/numpy-1.24.1.tar.gz"
  sha256 "2386da9a471cc00a1f47845e27d916d5ec5346ae9696e01a8a34760858fe9dd2"
  license "BSD-3-Clause"
  head "https://github.com/numpy/numpy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c2d94aba745492d1c158a858b8c0d86ab14bea8c5ba6a8bc354dbd09111aa217"
    sha256 cellar: :any,                 arm64_monterey: "1ea9f1bc734d43f9e20b355e6fd8a7e6e4fd2c65add0345ab67b76aadc81f497"
    sha256 cellar: :any,                 arm64_big_sur:  "bff6473aa5f37b5843d49b37216fa555058de07c9372310dc90642c75baefcc3"
    sha256 cellar: :any,                 ventura:        "f1b617fffde1079a476568c08ae314ab8d6db8c6c97ddf9eb8725a9c51ba16a9"
    sha256 cellar: :any,                 monterey:       "4e65c59840571c05d3d378bb52c9cab45b1e1d9806ee51b0030999ec7f11c438"
    sha256 cellar: :any,                 big_sur:        "3e82b251208ab3e91fe331ad8f00858d6f15dbea48e57928ae794a014197e7e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3466825156b5b810dc41858d9cf79626ee62080f302cd1dc9883eaf7c2e0bc7"
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
