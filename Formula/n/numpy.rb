class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/dd/2b/205ddff2314d4eea852e31d53b8e55eb3f32b292efc3dd86bd827ab9019d/numpy-1.26.2.tar.gz"
  sha256 "f65738447676ab5777f11e6bbbdb8ce11b785e105f690bc45966574816b6d3ea"
  license "BSD-3-Clause"
  head "https://github.com/numpy/numpy.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sonoma:   "11bc5c6da12546b8bb991103e46ac32a3814a8c0476ba969e3df5d7fe81d37f7"
    sha256 cellar: :any,                 arm64_ventura:  "01702f2f857e3cc998ae40bff238b4ffe1a9ccd016df4b5b29cf553068d84f52"
    sha256 cellar: :any,                 arm64_monterey: "ae264192e83431c837544c3ae1d4465e43b69af31835ca6b33a40d0248038129"
    sha256 cellar: :any,                 sonoma:         "ae3ffe77db87552bc4ce103201423bcdf76d78e292adae85af2175ec363dd7fd"
    sha256 cellar: :any,                 ventura:        "0870dcf584ccd1fe4c94436cd60186a93c9096f73529610b985b7b143411f177"
    sha256 cellar: :any,                 monterey:       "5ac8788d861e2908516c77d57b61806578c72fbb212006014178e2e92e19b99f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a44bc16fb7cade85ed4466d685cfd8262a9ebc16392c95c1d8aa245aeeb7eedf"
  end

  depends_on "gcc" => :build # for gfortran
  depends_on "libcython" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "openblas"

  fails_with gcc: "5"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .sort_by(&:version) # so that `bin/f2py` and `bin/f2py3` use newest python
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
      python_exe = python.opt_libexec/"bin/python"
      site_packages = Language::Python.site_packages(python_exe)
      ENV.prepend_path "PYTHONPATH", Formula["libcython"].opt_libexec/site_packages

      system python_exe, "setup.py", "build", "--fcompiler=#{Formula["gcc"].opt_bin}/gfortran",
                                              "--parallel=#{ENV.make_jobs}"
      system python_exe, *Language::Python.setup_install_args(prefix, python_exe)
    end
  end

  def caveats
    <<~EOS
      To run `f2py`, you may need to `brew install #{pythons.last}`
    EOS
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", <<~EOS
        import numpy as np
        t = np.ones((3,3), int)
        assert t.sum() == 9
        assert np.dot(t, t).sum() == 27
      EOS
    end
  end
end
