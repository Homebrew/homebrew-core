class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/d0/ad/fed0499ce6a338d2a03ebae59cd15093910c8875328855781952abf6c2fe/numpy-2.4.6.tar.gz"
  sha256 "f3a3570c4a2a16746ac2c31a7c7c7b0c186b95ce902e33db6f28094ed7387dda"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/numpy/numpy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5ef92c50bed046b19595854c16e7e0c4ed1da377f511516765b83041c44317b1"
    sha256 cellar: :any,                 arm64_sequoia: "5d794662e2b985a9d9ff44a89df735ddd79a1004c455481de4dac9f5df81af3e"
    sha256 cellar: :any,                 arm64_sonoma:  "8153b42f341376b86264c2a9ab547926b8b1d6a6575511eef4eecd50248596be"
    sha256 cellar: :any,                 sonoma:        "c3d871e7a22445d0c3289cfadaca65467f9a33045f4d9da97f52d552f279da7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fcdd86fb98663ea0af0e9de6f3d568ead0b62260be482057e68a50bf8c7ca04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87a75aa5d64222a2b6ad81464f823ae24df60b38df809692b865508cb9bcbacd"
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
