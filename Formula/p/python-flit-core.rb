class PythonFlitCore < Formula
  desc "Simplified packaging of Python modules"
  homepage "https://flit.pypa.io/"
  url "https://files.pythonhosted.org/packages/c4/e6/c1ac50fe3eebb38a155155711e6e864e254ce4b6e17fe2429b4c4d5b9e80/flit_core-3.9.0.tar.gz"
  sha256 "72ad266176c4a3fcfab5f2930d76896059851240570ce9a98733b658cb786eba"
  license "BSD-3-Clause"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "937c8669e970bdcc413d6e8f270933daeb066905fca7fd14b6644317742419a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2fb869b18beaa2f917611354966bd0c881bacdae369f54204bcd7c6230d11174"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42931497a3f72077673c529c1248c3065a3759dccb6b52aa0b29f9758af7eb6b"
    sha256 cellar: :any_skip_relocation, sonoma:         "1c1321fc0a8762b5956f5876e57d7af10bee2529e02dcca55d36e2ee52d54ece"
    sha256 cellar: :any_skip_relocation, ventura:        "f6e01f01a804537d77aa2f3d3fab83744738d4edc59c2b59c3994f335b0a84c4"
    sha256 cellar: :any_skip_relocation, monterey:       "8588bb813f51ca80f519df9a61cdb4f2993110e973a7c0d5c6a1aadb90b8f94e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b38d66244b70c3669f14150ce04a7b5c0e2be2df504dec90677d991e1534d812"
  end

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
