class MesonPython < Formula
  desc "Meson PEP 517 Python build backend"
  homepage "https://meson-python.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/a2/3b/276b596824a0820987fdcc7721618453b4f9a8305fe20b611a00ac3f948e/meson_python-0.15.0.tar.gz"
  sha256 "fddb73eecd49e89c1c41c87937cd89c2d0b65a1c63ba28238681d4bd9484d26f"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e0808f63a54ccefa7fc8d6a0b448f50539dc1c43766fd51ff21a670c816556b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "379571d4e7b31ea43feb22dcebc7e7a045e407f279dde449544b554606493c08"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37668cdcae637d0053cb0312200ab42eb51a8951c36ac0f0bdab4e4eac817c11"
    sha256 cellar: :any_skip_relocation, sonoma:         "9b0d50dd856c12acbc7b2d82409f2a970b4077e084e1add520347aeb21683213"
    sha256 cellar: :any_skip_relocation, ventura:        "7f196195e9bafffb20d757c8e9028ce6b762ea2f1817f8da544435d4332662d5"
    sha256 cellar: :any_skip_relocation, monterey:       "1a1d762498a9dd66d56b1e2924843bf43dcfcc3683ad86be3c3be5e5080af0c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "544afea0d36e1841c4e13c851d3b189e78e42e6624b864435f71a2f1fa7bd753"
  end

  depends_on "python-flit-core" => :build
  depends_on "python-setuptools" => :build
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
