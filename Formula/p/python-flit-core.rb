class PythonFlitCore < Formula
  desc "Simplified packaging of Python modules"
  homepage "https://flit.pypa.io/"
  url "https://files.pythonhosted.org/packages/c4/e6/c1ac50fe3eebb38a155155711e6e864e254ce4b6e17fe2429b4c4d5b9e80/flit_core-3.9.0.tar.gz"
  sha256 "72ad266176c4a3fcfab5f2930d76896059851240570ce9a98733b658cb786eba"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fa1716735f477ed42344b6cdf8031b42641973e7e86f5bb809c969a54c544773"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9a9274191de6bfce43de28a42c69d46872392ae478512ee5772b557b706046cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d928b6f53ba7b11976ee5c29443ef1fe37f211ae51a66f9840e8b94d4e5ffdd"
    sha256 cellar: :any_skip_relocation, sonoma:         "15185153ce26ff31dff6b0a24563c3491a83e4dbb10abcc38d513f8c6f77121f"
    sha256 cellar: :any_skip_relocation, ventura:        "5a83be01a7c51795a53c4f65a4f90a9421dd147cbd382f86fe00e7cf92e7e32d"
    sha256 cellar: :any_skip_relocation, monterey:       "9f59a01f0fbe2353791d85f7cab597b6486dd40f29849c3dbcd66fe282a39b67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0843bb770f825ec359f1638371d79de26b495319dacf041bf334bee0bc340d2d"
  end

  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

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
