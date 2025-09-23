class Pycparser < Formula
  desc "C parser in Python"
  homepage "https://github.com/eliben/pycparser"
  url "https://files.pythonhosted.org/packages/fe/cf/d2d3b9f5699fb1e4615c8e32ff220203e43b248e1dfcc6736ad9057731ca/pycparser-2.23.tar.gz"
  sha256 "78816d4f24add8f10a06d6f05b4d424ad9e96cfebf68a4ddc99c65c0720d00c2"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "20df01e401f66b31119275739885166b381c62cddac34c2af51b44c0e0c14d78"
  end

  depends_on "python@3.12" => [:build, :test]
  depends_on "python@3.13" => [:build, :test]

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python|
      system python, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
    end
    pkgshare.install "examples"
  end

  test do
    examples = pkgshare/"examples"
    pythons.each do |python|
      system python, examples/"c-to-c.py", examples/"c_files/basic.c"
    end
  end
end
