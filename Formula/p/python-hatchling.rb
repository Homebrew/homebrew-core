class PythonHatchling < Formula
  desc "Modern, extensible Python build backend"
  homepage "https://github.com/pypa/hatch/tree/master/backend"
  url "https://files.pythonhosted.org/packages/d8/a1/7dd1caa87c0b15c04c6291e25112e5d082cce02ee87f221a8be1d594f857/hatchling-1.21.1.tar.gz"
  sha256 "bba440453a224e7d4478457fa2e8d8c3633765bafa02975a6b53b9bf917980bc"
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

  resource "editables" do
    url "https://files.pythonhosted.org/packages/37/4a/986d35164e2033ddfb44515168a281a7986e260d344cf369c3f52d4c3275/editables-0.5.tar.gz"
    sha256 "309627d9b5c4adc0e668d8c6fa7bac1ba7c8c5d415c2d27f60f081f8e80d1de2"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
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
    url "https://files.pythonhosted.org/packages/44/e4/9de7cda4a03a996758fbdb7ddacc071b4c62fdcd645e0a1192a22e8c55c0/trove-classifiers-2024.1.8.tar.gz"
    sha256 "6e36caf430ff6485c4b57a4c6b364a13f6a898d16b9417c6c37467e59c14b05a"
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
