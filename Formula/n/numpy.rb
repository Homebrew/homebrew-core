class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/e1/78/31103410a57bc2c2b93a3597340a8119588571f6a4539067546cb9a0bfac/numpy-2.2.4.tar.gz"
  sha256 "9ba03692a45d3eef66559efe1d1096c4b9b75c0986b5dff5530c378fb8331d4f"
  license "BSD-3-Clause"
  head "https://github.com/numpy/numpy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f61324673c23c5686a5a62d82e1b18e41a9f2e6f5be8df337b476ce84e43dc2e"
    sha256 cellar: :any,                 arm64_sonoma:  "e065697d23a17737633449aab01744f8c565ed0c909b4d6ca1390bf41d01af78"
    sha256 cellar: :any,                 arm64_ventura: "ecb01a7fbf75d0339fea5692393cda95657986c8d4394ba69eafdef41bde9ffc"
    sha256 cellar: :any,                 sonoma:        "4a9ed3cd08c662b5690d0638cdaa2a56f35de79a41302661dbb64f6c44dbc641"
    sha256 cellar: :any,                 ventura:       "68833d1f5e559507d677cfd4be032687551d553559fa45ed6b4eeb8728a16a50"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00e8eb965972f432209b6949daa55926d52ac243dd6885d1e8d20f3e00cc16b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fff8d36503205449ca6f66b92b5855541f00b14c1ac172f026027f23a6ede58"
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
