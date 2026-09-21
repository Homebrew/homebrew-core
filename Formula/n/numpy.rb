class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/13/01/11703282db468b85f6f7b8c7f22d058de5970d5c7e60a3a8aaa313c3de36/numpy-2.5.3.tar.gz"
  sha256 "df2d5874ff183595a4ba404edd04f6bd9b5505c1d7708573f6a6c17489a67563"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/numpy/numpy.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "76cb4bdb653776e822fccb8937866410f82ea44dbd8b614603e3ea099b977fb5"
    sha256 cellar: :any, arm64_tahoe:       "bdcfe1be445140cfcb65a43bb8f99981a482cb43ad7dbc4a76ffc22a62f66ac5"
    sha256 cellar: :any, arm64_sequoia:     "3a29ad16b006dd043b9e6241bb7dde3760a7c1ad53a66b8ddd8163bb6532816b"
    sha256 cellar: :any, arm64_sonoma:      "1dc2d1e20c18507d3e5fc8f06ffb970de14f28d2e1da064b365c526c08c55a96"
    sha256 cellar: :any, arm64_linux:       "b99c2ae58c9289d0ba396ee27fd47b67c4d6a8b5ea277ec2383821a5b219104c"
    sha256 cellar: :any, x86_64_linux:      "1198f57045ae41ff962b09393c35a7bad9d077b3bb596985d26756ccc23c9fc7"
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
