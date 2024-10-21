class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/4b/d1/8a730ea07f4a37d94f9172f4ce1d81064b7a64766b460378be278952de75/numpy-2.1.2.tar.gz"
  sha256 "13532a088217fa624c99b843eeb54640de23b3414b14aa66d023805eb731066c"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/numpy/numpy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3ee05c1dc6ae5c2b979185366671d2001fc9eb3e9992772759c09cbd082d9cf3"
    sha256 cellar: :any,                 arm64_sonoma:  "f817053b37b367828004a068572c344b22ec9c1cf697e2c7827f22cb4762be7d"
    sha256 cellar: :any,                 arm64_ventura: "24a9db255e759e7dd4dd6c5e23c69c1882c494db5d99eb3d4318e8e817458fe1"
    sha256 cellar: :any,                 sonoma:        "775342f4ab756239003b82987eeac565893c84da6e2aadd4869a14138805bd43"
    sha256 cellar: :any,                 ventura:       "a3d6ef5a502e48ab43b27a14d3d50a5b434cc78f6518e285236fbf5ed27e0b8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b76202d1b5235a66a494d0e6e6c8d707fe4ad854e9999afc0ae1cc1eec1b8a95"
  end

  depends_on "gcc" => :build # for gfortran
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "python@3.13" => [:build, :test]
  depends_on "openblas"

  on_linux do
    depends_on "patchelf" => :build
  end

  fails_with gcc: "5"

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
      system python3, "-c", <<~EOS
        import numpy as np
        t = np.ones((3,3), int)
        assert t.sum() == 9
        assert np.dot(t, t).sum() == 27
      EOS
    end
  end
end
