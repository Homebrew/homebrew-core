class MesonPython < Formula
  desc "Meson PEP 517 Python build backend"
  homepage "https://meson-python.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/38/a7/ddc350902a1b3b960db8d0e501f61468f925f994e0b4e6d696aeb6a75c00/meson_python-0.14.0.tar.gz"
  sha256 "b96866690326544dfe452583753ac3f43313227e9fd9416701a8df90af212234"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "affd6140dfeed5e48c1b832d4a95607899f55f8785c20b6992ca65bc777371d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6090f97a35767a42780d4860e0fa601632d664066c6fab915c84efa3027d8b06"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34886da80ab2a00676808504e60979902ee1520f515f1fb0cca763ef4933c0b6"
    sha256 cellar: :any_skip_relocation, sonoma:         "2d09f6699329347599b8eb814c41ee99180e2b28225edcebb859fe4b7341ef9c"
    sha256 cellar: :any_skip_relocation, ventura:        "17bc9bc95d1af5d74906a1be9c0722104f3e01547151aee2041056eeed273869"
    sha256 cellar: :any_skip_relocation, monterey:       "0f6b24ed5e0eb5b5fbefee6877e72bd25a752d4972f4ff760ec0a1948f9969fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db276acd242f90eed155d6fb961eded65a00a4d05b64006df6531d3f97f5e0f3"
  end

  depends_on "python-flit-core" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
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
