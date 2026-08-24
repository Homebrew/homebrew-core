class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/9a/80/db0b4559e57ec36362bedbb05530a87fafbcb6067708c946967a41d449e7/numpy-2.5.2.tar.gz"
  sha256 "d482d171c406ae88c5b19cad3b6a1c4c5209f886ab74bc44c2c865c23f52d860"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/numpy/numpy.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "79599e535b1734f014ad1ec68aeda7c619ac1ced19f6e293694e03be31cea0db"
    sha256 cellar: :any, arm64_sequoia: "13ffde10d22503d6d175259dd976bdd9ece48bd5394c265019fdfef511d39bf3"
    sha256 cellar: :any, arm64_sonoma:  "963455dd34681c6856ab5439455090ddf29d5ba2a91f6c7e9abe1710ae94fd49"
    sha256 cellar: :any, sonoma:        "29cb5dcd989660db43568ad9625ad4c887e03b4a826dc9cd2c083dde2efaf7d4"
    sha256 cellar: :any, arm64_linux:   "a498040292ba447fe2e8d57f8906412af7090213ca1aea91c97faf5498f342a4"
    sha256 cellar: :any, x86_64_linux:  "af579a2d9ccbe6c3090025f4e39c6591827ede89d6f71fd16785acf413b08880"
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
