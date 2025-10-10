class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/d0/19/95b3d357407220ed24c139018d2518fab0a61a948e68286a25f1a4d049ff/numpy-2.3.3.tar.gz"
  sha256 "ddc7c39727ba62b80dfdbedf400d1c10ddfa8eefbd7ec8dcb118be8b56d31029"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/numpy/numpy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "34d42def26097e627caf825e1bba8de5d3ec03820be5ef13c586907d19572859"
    sha256 cellar: :any,                 arm64_sequoia: "3919636d71454d3eb2159dc7237bb0c22335d4a695f176026fe2e80aa0b407c6"
    sha256 cellar: :any,                 arm64_sonoma:  "c701ff50ffeee5c525c812ae01ed972d62eb7c87e7d99f4fc99d53a3a9a4601e"
    sha256 cellar: :any,                 sonoma:        "b09a30417282e167c06c1d5994031346147e91eaad37da2a6509414540778ca0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee90a22cbece9079cb8fea55de4503979e2876dddbd32f965757019f4fd4150c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10d748b52fcc0f7c15196aa6104ad43c55356edf40888be9eed32b11fd19409c"
  end

  depends_on "gcc" => :build # for gfortran
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "python@3.12" => [:build, :test]
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
