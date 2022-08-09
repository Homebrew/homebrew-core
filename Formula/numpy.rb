class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/13/b1/0c22aa7ca1deda4915cdec9562f839546bb252eecf6ad596eaec0592bd35/numpy-1.23.1.tar.gz"
  sha256 "d748ef349bfef2e1194b59da37ed5a29c19ea8d7e6342019921ba2ba4fd8b624"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/numpy/numpy.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_monterey: "786270c62f9b186f40b113a86b812f9e324b79f18662dc4d6f63c8f43114bc35"
    sha256 cellar: :any, arm64_big_sur:  "8ccb46daa9c60ae684e2a7f3cb94cb4614a1dcbdddb290b8b83e5d4d4ea1105a"
    sha256 cellar: :any, monterey:       "28b59d14ba8278f274ac7c2728f763e8b97baff751eb64d941b1b2c2e597fccc"
    sha256 cellar: :any, big_sur:        "ee6ba26e160a73ecb28775b83c21164b0d4f149b1dc89349672b5e4ce191b257"
    sha256 cellar: :any, catalina:       "11a97f6a647a06a8091cc7dcd23907aa965870fe12506246555fb61c9abf164c"
    sha256               x86_64_linux:   "b2eaa057ade9bbd53cec9995da0237116dbb6a5a8c9703fb4df954881ca74ff3"
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
