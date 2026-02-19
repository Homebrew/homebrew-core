class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/57/fd/0005efbd0af48e55eb3c7208af93f2862d4b1a56cd78e84309a2d959208d/numpy-2.4.2.tar.gz"
  sha256 "659a6107e31a83c4e33f763942275fd278b21d095094044eb35569e86a21ddae"
  license "BSD-3-Clause"
  head "https://github.com/numpy/numpy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "76cf75c83480e6c311b83bc8886de9156e7333d6c7112bc3849af844cd7bcab1"
    sha256 cellar: :any,                 arm64_sequoia: "bfa15a975fb9247b8416c4f0e4059c8c92d1636b9ef480ea17352f0f7160468b"
    sha256 cellar: :any,                 arm64_sonoma:  "c137423f8b829eb83b76ea565b7c282c2b7d421e9682eda654879983c56ae82d"
    sha256 cellar: :any,                 sonoma:        "fc6e7e35f19bed542c3b2cc78b89f5871af9cf8dd85853cfa22193a354a2ce32"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa62c62178dba4b46e6f4260a8b3029f09a57142ef22d2f3b7287e636d7f9f9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dcd0f7306c84ac0a357914a40bbcd7f6bcebbdc56a31544eb0e0176b3bfc7ec4"
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
