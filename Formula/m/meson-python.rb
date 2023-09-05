class MesonPython < Formula
  desc "Meson PEP 517 Python build backend"
  homepage "https://meson-python.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/38/a7/ddc350902a1b3b960db8d0e501f61468f925f994e0b4e6d696aeb6a75c00/meson_python-0.14.0.tar.gz"
  sha256 "b96866690326544dfe452583753ac3f43313227e9fd9416701a8df90af212234"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd3d3b4c2a81a73c42920a22618d9f1a369b903caec4e7913e8ed0f9cd30c53c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6e91d3cae06f6b404ec82692abecbc5e80b91bbfe1b3033372e53dbb11455da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e59e0b0f444a63c3878fb38aadc97d962396653b987c7b9f7548d8cf9589ae23"
    sha256 cellar: :any_skip_relocation, ventura:        "59c8ead60df5be007b22238417b54081e9cd86f11265ed8bc88c423dfa7db44f"
    sha256 cellar: :any_skip_relocation, monterey:       "70ca3ff7fed63ac1d0786f89d642c4af5d2856a44832cc84b20aebcf2d038f1d"
    sha256 cellar: :any_skip_relocation, big_sur:        "02fd596cde092e6dbcca4739252742897d0548bb7760e1df1efcd9929fa0a561"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e24e93d601a9a7f1f165ead6ac460b36cae3657afa5841e151db276c33f6e37a"
  end

  depends_on "python-flit-core" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.9" => [:build, :test]
  depends_on "meson"
  depends_on "python-packaging"

  resource "pyproject-metadata" do
    url "https://files.pythonhosted.org/packages/38/af/b0e6a9eba989870fd26e10889446d1bec2e6d5be0a1bae2dc4dcda9ce199/pyproject-metadata-0.7.1.tar.gz"
    sha256 "0a94f18b108b9b21f3a26a3d541f056c34edcb17dc872a144a15618fed7aef67"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/c0/3f/d7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3/tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
  end

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      site_packages = Language::Python.site_packages(python)
      ENV.prepend_create_path "PYTHONPATH", libexec/"vendor"/site_packages
      python_exe = python.opt_libexec/"bin/python"

      resources.each do |r|
        r.stage do
          system python_exe, "-m", "pip", "install", *std_pip_args(prefix: libexec/"vendor"), Pathname.pwd
        end
      end

      system python_exe, "-m", "pip", "install", *std_pip_args(prefix: libexec/"vendor"), "."
      (prefix/site_packages/"homebrew-deps.pth").write libexec/"vendor"/site_packages
    end
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "import mesonpy"
    end
  end
end
