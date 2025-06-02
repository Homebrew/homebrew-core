class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/76/21/7d2a95e4bba9dc13d043ee156a356c0a8f0c6309dff6b21b4d71a073b8a8/numpy-2.2.6.tar.gz"
  sha256 "e29554e2bef54a90aa5cc07da6ce955accb83f21ab5de01a62c8478897b264fd"
  license "BSD-3-Clause"
  head "https://github.com/numpy/numpy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "015951ce3ac8d4580c7d65ab01da55253e7fbbe196f14da546511f1e0bf76866"
    sha256 cellar: :any,                 arm64_sonoma:  "db8fc4fb6a7d3014c09f9385b85e60b160f18c537924f729c54e24e4f7e7d522"
    sha256 cellar: :any,                 arm64_ventura: "e1b6497914bb0181a845af0be3d96a016a8b86e03ce0b85b8baccb8ab4d939bc"
    sha256 cellar: :any,                 sonoma:        "886e8a12f2d386ff22b8b24397086920d30c9e2f7a24819dcabd24519ffb2e8e"
    sha256 cellar: :any,                 ventura:       "3ab83826239866b15cd57b0207c96393f44c7850ed57212b7dafde21aa36ef0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fa25795190a56d8e7cb7b1c7e7e45186f37008198722730a7eca17d3654bd74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c8119202fb8599cec02bb32936b2149f090c9495970d96c3b47fb1e6eb7e0d8"
  end

  depends_on "gcc" => :build # for gfortran
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "python@3.12" => [:build, :test]
  depends_on "python@3.13" => [:build, :test]
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
