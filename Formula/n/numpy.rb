class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/a0/41/8f53eff8e969dd8576ddfb45e7ed315407d27c7518ae49418be8ed532b07/numpy-1.25.2.tar.gz"
  sha256 "fd608e19c8d7c55021dffd43bfe5492fab8cc105cc8986f813f8c3c048b38760"
  license "BSD-3-Clause"
  head "https://github.com/numpy/numpy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b2857ab33878b186ca6ba7b393880b896dae635910c64c836c69d26ed7b1e21"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e71e677dd4bba02e4405edfd18a8a42a3c97aa2939d3ad4f19fd559439c73b4f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9261500947480f8d117fd461da35f8ace01db25f9aa63b2a560214cab1f9b8bf"
    sha256 cellar: :any_skip_relocation, ventura:        "b98d485113438533665f9ea94f48f74d3b15ddc40dc0581c8d70a2c8e4293629"
    sha256 cellar: :any_skip_relocation, monterey:       "602c409ac566f4d84a5f7670673d3e5e43d216beefd37d8200c8ab8cec0f405c"
    sha256 cellar: :any_skip_relocation, big_sur:        "edbe293de8f1c9716bf773b2b36425a6adcf915ec1963ac14e019b0b39740fce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15e190707dc82a004e8df3f9942b2eb0194a3c7c85e8698f6c45b2a2a6ba6f1f"
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
