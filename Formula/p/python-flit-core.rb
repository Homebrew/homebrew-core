class PythonFlitCore < Formula
  desc "Simplified packaging of Python modules"
  homepage "https://flit.pypa.io/"
  url "https://files.pythonhosted.org/packages/c4/e6/c1ac50fe3eebb38a155155711e6e864e254ce4b6e17fe2429b4c4d5b9e80/flit_core-3.9.0.tar.gz"
  sha256 "72ad266176c4a3fcfab5f2930d76896059851240570ce9a98733b658cb786eba"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "99f506823b56ed90a242ad9b6c32901e44ade90e65923f1843760e90d8d7ed0f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a16f4279d40d8da93f3d79cd3d57efd4d13d60f5c69a2d05384984704a23f92e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3875414eb6da4a27a6f44355a755733603c3bbb1a0dc3764ebb3eb0749b836c9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a684150f99c000a712972736e5a43def33a8290e70e295dac841370ed7397918"
    sha256 cellar: :any_skip_relocation, sonoma:         "0d62e42c5cdc49c8a58c2886a497eb6756f2fbb30b3befae7fb28c989b7c5167"
    sha256 cellar: :any_skip_relocation, ventura:        "bea494fa3cc4372059c0d6324bb515ae9b7773dcb5c425d4b1a06776a8b042c7"
    sha256 cellar: :any_skip_relocation, monterey:       "b75d796164d46148bae037e8643c1cab02eb52da68774455fa5973a86baf0dba"
    sha256 cellar: :any_skip_relocation, big_sur:        "480436fca3bcee0a484bac311cfd69970a68030bda3e5d6c7a84c0a7d0dfc23f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03cf4d1782ed2c9b6db2ddd7a9f08c107527ad8e8d2f77dbd53f6303d7cc7a10"
  end

  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.9" => [:build, :test]

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "import flit_core"
    end
  end
end
