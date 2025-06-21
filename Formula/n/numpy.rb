class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/2e/19/d7c972dfe90a353dbd3efbbe1d14a5951de80c99c9dc1b93cd998d51dc0f/numpy-2.3.1.tar.gz"
  sha256 "1ec9ae20a4226da374362cca3c62cd753faf2f951440b0e3b98e93c235441d2b"
  license "BSD-3-Clause"
  head "https://github.com/numpy/numpy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9f6f60e2be311759e7efaba77eaca8745b746b5d48d2b1472e80f053c35c8de6"
    sha256 cellar: :any,                 arm64_sonoma:  "d0088dde5437fb81e49b2ebc04a561f738aad118737ef12e36fc1cb29715b7ac"
    sha256 cellar: :any,                 arm64_ventura: "ee872d853a2bc5e877ba65abb53188b9eb36f59e4f3e57be560c94a0c4ad7bfc"
    sha256 cellar: :any,                 sonoma:        "b846369ec2021b66df32f17ba7963dd445ef5d2246c551c9d1b7bf69492a08ea"
    sha256 cellar: :any,                 ventura:       "9ab136f0b32d1630ff1378e0065a8cf67f19240dcca56d37e5ef8a40266a36ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6303dd05bb3f6bc76e779c6968e09b42ac4ed62cc9ec107b493b23eba9bd1626"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fc94014a1a4c0479e619865109834491b776edfdae48dd5caffd19038b06217"
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
