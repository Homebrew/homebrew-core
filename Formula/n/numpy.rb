class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/78/23/f78fd8311e0f710fe1d065d50b92ce0057fe877b8ed7fd41b28ad6865bfc/numpy-1.26.1.tar.gz"
  sha256 "c8c6c72d4a9f831f328efb1312642a1cafafaa88981d9ab76368d50d07d93cbe"
  license "BSD-3-Clause"
  head "https://github.com/numpy/numpy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "71a58b40fe414681587f46601a88eeb96cc9c2a63944011124201cb572b2726e"
    sha256 cellar: :any,                 arm64_ventura:  "9a9f0a928fae2826e8eb6d9eabf95d93c241cc391817417cce4ae9c5d26527b3"
    sha256 cellar: :any,                 arm64_monterey: "ad83cd435edc61f9bbf47143e5336f032ebba9321be5ddfd8fd9d9111ae3b9e6"
    sha256 cellar: :any,                 sonoma:         "1d431da9eea6706f0d4219f31bf954afbea99b310fdf1b6e5d27a553c27edf1e"
    sha256 cellar: :any,                 ventura:        "bf5a14d971ca62b92fcbeec2c9c2a1dc725da2d7252ad58618454bcbf583c3e9"
    sha256 cellar: :any,                 monterey:       "6949801aab8b25b77bc3a65fa461a1701f4fb9f822baaf87939d208548c2714e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bdbbb051cdfc748eb35df216b67dbb70c17f7f4952dbdf419efa82b594d57637"
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
