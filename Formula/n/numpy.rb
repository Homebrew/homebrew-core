class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/76/65/21b3bc86aac7b8f2862db1e808f1ea22b028e30a225a34a5ede9bf8678f2/numpy-2.3.5.tar.gz"
  sha256 "784db1dcdab56bf0517743e746dfb0f885fc68d948aba86eeec2cba234bdf1c0"
  license "BSD-3-Clause"
  head "https://github.com/numpy/numpy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4be91ded8c875daa819962be2c8770c14d7a2876a0d42f02bdfc5a5bd178575f"
    sha256 cellar: :any,                 arm64_sequoia: "c4f891fa476bb517ab7b31041fcbae91ea1f536bc035eb7399c24ac8416adcd2"
    sha256 cellar: :any,                 arm64_sonoma:  "b1409092478a9407ae1c7d35afac8a23daf131a7df99fd4ac37b1743e49b4053"
    sha256 cellar: :any,                 sonoma:        "992093da4d18a2b357527edceed56b6254c7b87bcb8f0150c209aee76b50e0e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "821605d5a452d913ea5c7448b7cac419b6ef646d1fc40e9734ee5a4dcf6c3695"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7b684580412511fd70fcb68c12271e96a0d68660670832a6206d6480a5992e6"
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
