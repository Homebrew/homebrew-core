class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/55/b3/b13bce39ba82b7398c06d10446f5ffd5c07db39b09bd37370dc720c7951c/numpy-1.26.0.tar.gz"
  sha256 "f93fc78fe8bf15afe2b8d6b6499f1c73953169fad1e9a8dd086cdff3190e7fdf"
  license "BSD-3-Clause"
  head "https://github.com/numpy/numpy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a2fb7bec92f82adc47fe6fde5782d7ec759a6c4dc4b254e73eab762eef2b9a27"
    sha256 cellar: :any,                 arm64_ventura:  "84871269dd88e566e45580502281344476f24b18f42981cf3508b435549a7f09"
    sha256 cellar: :any,                 arm64_monterey: "160404ff6361282a7123f134057ee7b14c59c217e8a6decb8e7d4348da48ca17"
    sha256 cellar: :any,                 arm64_big_sur:  "b64d66ec268a9f3a74e451ddb7f4d720a1e9d4f87a913120d771e50bb4785aa5"
    sha256 cellar: :any,                 sonoma:         "796703f76d70f13ab38bea2fbb063f255b2192671a4f3b01fc55984f44d52134"
    sha256 cellar: :any,                 ventura:        "ab9192c90029797beaa981f07897852b1451588a885f0f7bb92735f054d8bc2f"
    sha256 cellar: :any,                 monterey:       "f5cb725503d3a1c7d5ad71eb229863385f9445355f39398ab4c22e8b6075c924"
    sha256 cellar: :any,                 big_sur:        "d5f6d20fc2eadea5c6564541e99270cb7657731de82324c412037b27241fb888"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d10a731a2d99c61a6eca2227f395abd3298c50de0f28ff99074bf7258274cba"
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
