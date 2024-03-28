class Pycparser < Formula
  desc "C parser in Python"
  homepage "https://github.com/eliben/pycparser"
  url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
  sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  license "BSD-3-Clause"
  revision 1

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "9de5a8333f6bd80fbabc628432c7cf04ef5642d4e03f42fc542483537af50476"
  end

  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

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
