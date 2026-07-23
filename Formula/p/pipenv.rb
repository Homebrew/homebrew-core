class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https://github.com/pypa/pipenv"
  url "https://files.pythonhosted.org/packages/26/4e/24ece5e63a4a81034453970e2289896f977999550abee4dcf81f1e0e963e/pipenv-2026.6.2.tar.gz"
  sha256 "fe513e97f3fc7027df22647aaf2b9de892f345f7e56dc0422e70b1213d641400"
  license "MIT"
  revision 1
  head "https://github.com/pypa/pipenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fe8e1e72d3ebb34e339923f6b3f8e1b14dd6b4c4dd8e3dd9d23e83b38ae67830"
  end

  depends_on "certifi" => :no_linkage
  depends_on "python@3.14"

  pypi_packages package_name:     "pipenv[completion]",
                exclude_packages: "certifi"

  def python3
    "python3.14"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/95/c0/c8e94135e66fabf89a120d9b4b123fe6993506beca6c1938a74c24cfa5fd/argcomplete-3.7.0.tar.gz"
    sha256 "afde224f753f874807b1dc1414e883ab8fe0cda9c04807b6047dcb8e1ac23913"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/c9/02/bd72be9134d25ed783ecbbc38a539ffaefbf90c78418c7fb7229600dbac7/distlib-0.4.3.tar.gz"
    sha256 "f152097224a0ae24be5a0f6bae1b9359af82133bce63f98a95f86cae1aede9ed"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/35/94/00f2059e4835eace3ae8fde680b932c496f8ec7bdc99168dfa53fb2e6b79/filelock-3.29.7.tar.gz"
    sha256 "5b481979797ae69e72f0b389d89a80bdd585c260c5b3f1fb9c0a5ba9bb3f195d"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d7/47/e4501f49c178ae1d9f4a75073fda4204f52647993f075a9db4d14930e0c5/platformdirs-4.10.0.tar.gz"
    sha256 "31e761a6a0ca04faf7353ea759bdba55652be214725111e5aac52dfa29d4bef7"
  end

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/4c/81/58c70036dffeccb7fe7d79d6260c69f7a28272bbd3909c29a01ea9422744/python_discovery-1.4.4.tar.gz"
    sha256 "5cad33982d412c1f3ffb8f9ca4ea292c9680bca3942451d30b69c37fce53a4a3"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/34/26/f5d29e25ffdb535afef2d35cdb55b325298f96debd670da4c325e08d70f4/setuptools-83.0.0.tar.gz"
    sha256 "025bccbbf0fa05b6192bc64ae1e7b16e001fd6d6d4d5de03c97b1c1ade523bef"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/34/d9/b477fddb68840b570af8b22afe9b035cbc277b5fb7b33dea390617a8b10f/virtualenv-21.6.1.tar.gz"
    sha256 "15f978b7cd329f24855ff4a0c4b4899cc7678589f49adbdcbbb4d3232e641128"
  end

  def install
    venv = virtualenv_install_with_resources

    generate_completions_from_executable(libexec/"bin/register-python-argcomplete", "pipenv", "--shell")

    # Build an `:all` bottle by replacing comments
    file = venv.site_packages.glob("argcomplete-*.dist-info/METADATA")
    inreplace file, "/opt/homebrew/bin/bash", "$HOMEBREW_PREFIX/bin/bash"
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    system bin/"pipenv", "--python", which(python3)
    system bin/"pipenv", "install", "requests"
    system bin/"pipenv", "install", "boto3"
    assert_path_exists testpath/"Pipfile"
    assert_path_exists testpath/"Pipfile.lock"
    assert_match "requests", (testpath/"Pipfile").read
    assert_match "boto3", (testpath/"Pipfile").read
  end
end
