class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/2c/d4/590ae7df5044465cc9fa2db152ae12468694d62d952b1528ecff328ef7fc/numpy-1.24.3.tar.gz"
  sha256 "ab344f1bf21f140adab8e47fdbc7c35a477dc01408791f8ba00d018dd0bc5155"
  license "BSD-3-Clause"
  head "https://github.com/numpy/numpy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8641002b1167ff35c5a5ddb2d96ca0f4c8a870b1bf760da1cf2021cd62eed9e5"
    sha256 cellar: :any,                 arm64_monterey: "acf12f121bdbf654434d9d90656ddbe2c64ad1b6b334833e4856e2fc7e03fa89"
    sha256 cellar: :any,                 arm64_big_sur:  "22ca7c78d6be758e037a9e490f490b6c40cd959b27446d3b4b1fab97ce8d61b2"
    sha256 cellar: :any,                 ventura:        "bc46ae4d5a56a3828c218bde3523c345dc91beab5585c54ae02f986e7dc5bc44"
    sha256 cellar: :any,                 monterey:       "ecd8697cd5c3480da8929eab696752da51d2c1a9a38b5fca11eb570a6c16dd56"
    sha256 cellar: :any,                 big_sur:        "498d1de23619b9ad83d98be4eaa9359e2bcd29561c3dc83bbc9ebac86f662e98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07d0b804bc48ff55d248f062846736eccb389cad8b1ea9b03f6db1352e50dd3c"
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
