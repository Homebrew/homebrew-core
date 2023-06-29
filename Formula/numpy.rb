class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/d0/b2/fe774844d1857804cc884bba67bec38f649c99d0dc1ee7cbbf1da601357c/numpy-1.25.0.tar.gz"
  sha256 "f1accae9a28dc3cda46a91de86acf69de0d1b5f4edd44a9b0c3ceb8036dfff19"
  license "BSD-3-Clause"
  head "https://github.com/numpy/numpy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2e21b0a3099ae6c992b3032092b52f3f98a88d592444c33f426632f32d0314b0"
    sha256 cellar: :any,                 arm64_monterey: "de602878d785d1b2f047f592737f65f82745e0b68c6d2f8e1eb7a6b29cdabec6"
    sha256 cellar: :any,                 arm64_big_sur:  "8d1abe02082b3b5c592682d3d4e1b439efde45f61bc94297669b3804cc3cef3c"
    sha256 cellar: :any,                 ventura:        "dad124f41a57d1a6f23931c16202177a75e5b2e76565d65250d799bfaee284ac"
    sha256 cellar: :any,                 monterey:       "d21aa1a6f2cb40d729e1fee750a7c73b6829f0195ac7c7073befd27182d2641e"
    sha256 cellar: :any,                 big_sur:        "bf699a5e353aabc384f95121d0f5f7fa3035108abe5dccea74c1aa11d7a25eca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1ddeaf8a7143357a1c7951e430fed4cd0a9708e03c4859e6158caf71bb67f44"
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
