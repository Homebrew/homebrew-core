class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/64/8e/9929b64e146d240507edaac2185cd5516f00b133be5b39250d253be25a64/numpy-1.23.4.tar.gz"
  sha256 "ed2cc92af0efad20198638c69bb0fc2870a58dabfba6eb722c933b48556c686c"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/numpy/numpy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1628291537d1068debe1cf0c97e60f4f2a9f121bfcc65d38ce0fdde463c903a7"
    sha256 cellar: :any,                 arm64_monterey: "91a1d1f26d68b2a7fdddadb539723d2f38872c63f9ca1780c46754041be222fd"
    sha256 cellar: :any,                 arm64_big_sur:  "ca8577c0d90afc9a474cff8f8673fd0a6f0563cb8e8d2fb48fb2bbf8b60907ab"
    sha256 cellar: :any,                 monterey:       "a476ca6e4382083687d33d575a510e2e28dba212d82a59f07c0462173a0a72fb"
    sha256 cellar: :any,                 big_sur:        "ffa968c7d3eca638070cccbde496edb64fdaa4437ae1be7625e03dc1f992be0a"
    sha256 cellar: :any,                 catalina:       "41b7676be8392816c1a42f9c9fbfc54e2f409e153135ad9646fdba93362ef213"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f02e3d9210801b54d68dfedc32be5b99f441e0c564d29682b36ca00aef0702af"
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
