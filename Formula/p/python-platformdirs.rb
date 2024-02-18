class PythonPlatformdirs < Formula
  desc "Python package for determining appropriate platform-specific dirs"
  homepage "https://platformdirs.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/96/dc/c1d911bf5bb0fdc58cc05010e9f3efe3b67970cef779ba7fbc3183b987a8/platformdirs-4.2.0.tar.gz"
  sha256 "ef0cc731df711022c174543cb70a9b5bd22e5a9337c8624ef2c2ceb8ddad8768"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "66efa4b4b8498bee1807c74d7ce17fbef1632ebc06eff287059b7e7274bb321c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1deb91f2029cbc4796eee7c84709627531fd8b8223df5dfcf571cc7d5e58c4f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6bee7c128ab266aa698f3f5919860ea6273d3c093b34a7447097593dd3d119b6"
    sha256 cellar: :any_skip_relocation, sonoma:         "6907c0e67c0347679f101bd6cf37d48f84794a53c655d031df4e01f45170277a"
    sha256 cellar: :any_skip_relocation, ventura:        "906e76327aa0d20a85ad758a2a0cfe3a4c815a4ed1ab39f27af994e49e8599db"
    sha256 cellar: :any_skip_relocation, monterey:       "a108be8212d8f014f8cfc064f32221155749c6a8c9a825fe2c2354354e81b978"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50e66a1c25e0ab11277919fb28dacad0587fdae57bb38ea611d12d57f41308db"
  end

  depends_on "python-hatch-vcs" => :build
  depends_on "python-hatchling" => :build
  depends_on "python-setuptools" => :build
  depends_on "python-setuptools-scm" => :build
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
      system python_exe, "-c", "import platformdirs"
    end
  end
end
