class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/f4/66/17b8e95770478436bf968353c89683ce6f9e14d92e0d4fb3111c09ba18d2/numpy-1.23.2.tar.gz"
  sha256 "b78d00e48261fbbd04aa0d7427cf78d18401ee0abd89c7559bbf422e5b1c7d01"
  license "BSD-3-Clause"
  head "https://github.com/numpy/numpy.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_monterey: "b284ff6aa538939f427dc6a50c70d8c454e85ba3fe9889f1a4acafd53cf23c71"
    sha256 cellar: :any, arm64_big_sur:  "f66822d74874b3614ea0ba65861a7f75edc1e22468c89440aeef0644319f1dac"
    sha256 cellar: :any, monterey:       "8015542dac17e451d03eb099a7ff619495cb401114f27a8a0a617cf01dc0306f"
    sha256 cellar: :any, big_sur:        "b502b26f761b905efd9b2eaa385dcdbe43f1756a92935fb7b9146cb61bf61e5c"
    sha256 cellar: :any, catalina:       "97f68914c19ea4027394df979520ddc82c191079ee45d3760b98f18f035ec961"
    sha256               x86_64_linux:   "b8e2df7a9019f0c286c373a805f7e6e4111d6576637a6100d2a9eb8e6a6f46b3"
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
