class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/4b/d1/8a730ea07f4a37d94f9172f4ce1d81064b7a64766b460378be278952de75/numpy-2.1.2.tar.gz"
  sha256 "13532a088217fa624c99b843eeb54640de23b3414b14aa66d023805eb731066c"
  license "BSD-3-Clause"
  head "https://github.com/numpy/numpy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f6dfb8979382c5b8f4009f2fb0790c07633ac131cafbac25d0ba6a5181c3ed47"
    sha256 cellar: :any,                 arm64_sonoma:  "c42a5acfe86cd4a64ffd540c1ada1d736475cc89af8a7347b9fdd35e60bca2b0"
    sha256 cellar: :any,                 arm64_ventura: "67f31dcd66f17ec80b4f1445c2dbef87ea70015a457ec23fe5fd185f8d6c4e55"
    sha256 cellar: :any,                 sonoma:        "568350876e7b55e4922535185f2156e1b8b4561d1c816df02c4c9ed9b4d053ed"
    sha256 cellar: :any,                 ventura:       "de4f71b1652a5d7ff5ada3220e8ec4367f117387185f9d17de08788f95b11960"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da26a28fefc97adf777edde9c90f95724f6f9833adb1ef230771d2e36ba6b2c8"
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
