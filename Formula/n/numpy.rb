class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/10/8b/c265f4823726ab832de836cdd184d0986dcf94480f81e8739692a7ac7af2/numpy-2.4.3.tar.gz"
  sha256 "483a201202b73495f00dbc83796c6ae63137a9bdade074f7648b3e32613412dd"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/numpy/numpy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "94ed4dd7491ac65b384f166ab1eae578d37b128f635b9ad3fe48540a0bdb322e"
    sha256 cellar: :any,                 arm64_sequoia: "395a58c787fd82765c2e5385875dbf010d1a461f1886bec0b50362a5df3d8b7c"
    sha256 cellar: :any,                 arm64_sonoma:  "adba93ca297c596666c249f297d89e878662b423cfb62403e4ba9e80256efeed"
    sha256 cellar: :any,                 sonoma:        "f4fdfcb2861e82659c69a5ef3b4d0bd2d008aa2c829933a59fe5a12e2ae3a1af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04b9b0b42dd76f71139e81cc5592295f155245b3bc71ae6c8148313609a35cc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81b2d7fa0c10bd0e8305ccaeef3baf2bcf4c9dbc0384f1a7c78a51688f2bb108"
  end

  depends_on "gcc" => :build # for gfortran
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "python@3.13" => [:build, :test]
  depends_on "python@3.14" => [:build, :test]
  depends_on "openblas"

  on_linux do
    depends_on "patchelf" => :build
  end

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .sort_by(&:version) # so scripts like `bin/f2py` use newest python
  end

  def install
    pythons.each do |python|
      python3 = python.opt_libexec/"bin/python"
      system python3, "-m", "pip", "install", "-Csetup-args=-Dblas=openblas",
                                              "-Csetup-args=-Dlapack=openblas",
                                              *std_pip_args(build_isolation: true), "."
    end
  end

  def caveats
    <<~EOS
      To run `f2py`, you may need to `brew install #{pythons.last}`
    EOS
  end

  test do
    pythons.each do |python|
      python3 = python.opt_libexec/"bin/python"
      system python3, "-c", <<~PYTHON
        import numpy as np
        t = np.ones((3,3), int)
        assert t.sum() == 9
        assert np.dot(t, t).sum() == 27
      PYTHON
    end
  end
end
