class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/55/b3/b13bce39ba82b7398c06d10446f5ffd5c07db39b09bd37370dc720c7951c/numpy-1.26.0.tar.gz"
  sha256 "f93fc78fe8bf15afe2b8d6b6499f1c73953169fad1e9a8dd086cdff3190e7fdf"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/numpy/numpy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cf640b0b0a2c0820a29c1eeb5bcd1da674f8a82e36bebe38e85508f9194e333a"
    sha256 cellar: :any,                 arm64_ventura:  "899ecdfe6ff145dca696d4bd8520045c3aac7e4f843830d3e218b2da20afe9bd"
    sha256 cellar: :any,                 arm64_monterey: "3faa226ae88072a90ce3d3442d35cbc453f7c6532e365dbbd9c6e0afaba6ca35"
    sha256 cellar: :any,                 sonoma:         "4d9bade24fd88acad828c260ac79d48e2c4ca916a7e01ff2d2f78fe1c8349a33"
    sha256 cellar: :any,                 ventura:        "5c5600a520bf159f163266e6763c95e07f54325463c327ebda4ac90429e547f9"
    sha256 cellar: :any,                 monterey:       "f2f88057b1d4acd7c45a14351ea3c4d87348d37c49ceb0e2f92ad9c9ab99a5c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f810471d7e289e992d2caa18bcad3c546d9245728be6faa4d665728179bed69"
  end

  depends_on "gcc" => :build # for gfortran
  depends_on "libcython" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
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
