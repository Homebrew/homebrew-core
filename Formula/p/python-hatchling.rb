class PythonHatchling < Formula
  desc "Modern, extensible Python build backend"
  homepage "https://github.com/pypa/hatch/tree/master/backend"
  url "https://files.pythonhosted.org/packages/fd/9b/6c92b3078a5493ebba5a5e4cb805b8bfee4253d56bfe6e9e4d16c9b8d173/hatchling-1.22.1.tar.gz"
  sha256 "ad52ebe5dabbce8f7448f347e2a4f72700dcc7a1e3d93f6e69996f9df30bc129"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c48ba86bc1cd276e2bf96e2bf40ad46e1b4ad0a23e4f7b6703e763b58b27d321"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ac726dde71e495a1aea4ef973d66c989c999549f6f24acf7e107bc7022abe25"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "adc7d962cd743ba056a4510859fb3a49e88a067d727dff73e5df275acf9958af"
    sha256 cellar: :any_skip_relocation, sonoma:         "2a906195dfbc08e72a3a915da14312871113d33a61c7a3b00879e249b398b484"
    sha256 cellar: :any_skip_relocation, ventura:        "e3d21e601d7cdd9389be74d743b8f7ed50b53e07d137512d18a30672fd918011"
    sha256 cellar: :any_skip_relocation, monterey:       "7392d7610709d14ef76189becebaffcfacdcd2e6a64992949e3bf6877c1df837"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "673bfaff48d0d31b8a014374bb678fa0f2b4c9b6a4c37cf6e5e2b51c5840d77f"
  end

  depends_on "python-flit-core" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "python-packaging"
  depends_on "python-pathspec"
  depends_on "python-pluggy"
  depends_on "python-trove-classifiers"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/ca/bc/f35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbf/pathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/54/c6/43f9d44d92aed815e781ca25ba8c174257e27253a94630d21be8725a2b59/pluggy-1.4.0.tar.gz"
    sha256 "8c85c2876142a764e5b7548e7d9a0e0ddb46f5185161049a79b7e974454223be"
  end

  resource "trove-classifiers" do
    url "https://files.pythonhosted.org/packages/13/11/e13906315b498cb8f5ce5a7ff39fc35941e8291e914158157937fd1c095d/trove-classifiers-2024.3.3.tar.gz"
    sha256 "df7edff9c67ff86b733628998330b180e81d125b1e096536d83ac0fd79673fdc"
  end

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"

      resource("editables").stage do
        system python_exe, "-m", "pip", "install", *std_pip_args, "."
      end

      system python_exe, "-m", "pip", "install", *std_pip_args, "."

      pyversion = Language::Python.major_minor_version(python_exe)
      bin.install bin/"hatchling" => "hatchling-#{pyversion}"

      next if python != pythons.max_by(&:version)

      # The newest one is used as the default
      bin.install_symlink "hatchling-#{pyversion}" => "hatchling"
    end
  end

  def caveats
    <<~EOS
      To run `hatchling`, you may need to `brew install #{pythons.last}`
    EOS
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "import hatchling"
    end
  end
end
