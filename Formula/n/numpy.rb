class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  license "BSD-3-Clause"
  head "https://github.com/numpy/numpy.git", branch: "main"

  stable do
    url "https://files.pythonhosted.org/packages/65/6e/09db70a523a96d25e115e71cc56a6f9031e7b8cd166c1ac8438307c14058/numpy-1.26.4.tar.gz"
    sha256 "2a02aba9ed12e4ac4eb3ea9421c420301a0c6460d9830d74a9df87efa4912010"

    depends_on "python-setuptools" => :build
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e5a11ee6e1e4b3ead073e1ee05182f7b31d8b34a1c37902e74d2a944172d4f62"
    sha256 cellar: :any,                 arm64_ventura:  "65231d3b52bcd472a56efe82eada5118fcf157df462b4a3dcbb2460c0c751ee0"
    sha256 cellar: :any,                 arm64_monterey: "4c6d2747b3204fae2a75b4bd9a91e53971e6a394b7beaede5c331e34009a3072"
    sha256 cellar: :any,                 sonoma:         "bf6f3380a7785111ac70f62c9f6bf3aa5308f2c4edd61490acc554ee3a463d26"
    sha256 cellar: :any,                 ventura:        "a235a28c6f4b11202edd3034251372b90eae40305f0dd1db0e8d535cdc723307"
    sha256 cellar: :any,                 monterey:       "345e466d8cd392e68e54928053c3cc737d5dbbc5966a6fd86e4e0990da241177"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fed0cdb5f32d8df64d87ceadd4ed03c81e8320f2ba6f40b964e4a4e6a186ace"
  end

  depends_on "gcc" => :build # for gfortran
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "openblas"

  on_linux do
    depends_on "patchelf" => :build
  end

  fails_with gcc: "5"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .sort_by(&:version) # so that `bin/f2py` and `bin/f2py3` use newest python
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
