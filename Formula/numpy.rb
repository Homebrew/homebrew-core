class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/13/b1/0c22aa7ca1deda4915cdec9562f839546bb252eecf6ad596eaec0592bd35/numpy-1.23.1.tar.gz"
  sha256 "d748ef349bfef2e1194b59da37ed5a29c19ea8d7e6342019921ba2ba4fd8b624"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/numpy/numpy.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_monterey: "bc1fff7aebd0e4e1950919047fa68cbae0d9944ff5c64c926787dfdb74853115"
    sha256 cellar: :any, arm64_big_sur:  "db39ac8b4f587d356a0c697cdddf1e519a64e233481db6a763c675575140fde9"
    sha256 cellar: :any, monterey:       "5673d5eb3550d1f2d6cf9cdfd8d05b86d54c601855e25626e79cf080547ad365"
    sha256 cellar: :any, big_sur:        "c7374d6e1867dc1530755c670fc5a1c75c1d96fe20474bdec723c74c7a11e88c"
    sha256 cellar: :any, catalina:       "06996c0a0b43293a955e8dca3b4df1b7ea7bf5739609f9b104e56abcfa842bf9"
    sha256               x86_64_linux:   "05eacb0876be91f257348a96fb3c94c9b3d33a5a65c7c372953f9a822d8d8f7f"
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
        .sort_by(&:version) # so that `bin/f2py` and `bin/f2py3` use python3.10
        .map(&:opt_bin)
        .map { |bin| bin/"python3" }
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
      system python, *Language::Python.setup_install_args(prefix),
                     "--install-lib=#{prefix/site_packages}"
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
