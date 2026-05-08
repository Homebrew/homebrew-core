class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https://github.com/pypa/pipenv"
  url "https://files.pythonhosted.org/packages/a7/ec/7f4b692962c2ac364b95adda43b3de753f4f4b7984bc21e8ca70c1d591a8/pipenv-2026.6.1.tar.gz"
  sha256 "2b68298377fd141db42ddd55e38c188c846651aa6e17ac6b75ba9f1fb4c3bc9d"
  license "MIT"
  head "https://github.com/pypa/pipenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e196def743743f880ca01b6b2a2e76140a06d11d26810543a76e9988d2b75544"
  end

  depends_on "certifi" => :no_linkage
  depends_on "python@3.14"

  pypi_packages package_name:     "pipenv[completion]",
                exclude_packages: "certifi"

  def python3
    "python3.14"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/38/61/0b9ae6399dd4a58d8c1b1dc5a27d6f2808023d0b5dd3104bb99f45a33ff6/argcomplete-3.6.3.tar.gz"
    sha256 "62e8ed4fd6a45864acc8235409461b72c9a28ee785a2011cc5eb78318786c89c"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/96/8e/709914eb2b5749865801041647dc7f4e6d00b549cfe88b65ca192995f07c/distlib-0.4.0.tar.gz"
    sha256 "feec40075be03a04501a973d81f633735b4b69f98b05450592310c0f401a4e0d"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/b5/fe/997687a931ab51049acce6fa1f23e8f01216374ea81374ddee763c493db5/filelock-3.29.0.tar.gz"
    sha256 "69974355e960702e789734cb4871f884ea6fe50bd8404051a3530bc07809cf90"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/9f/4a/0883b8e3802965322523f0b200ecf33d31f10991d0401162f4b23c698b42/platformdirs-4.9.6.tar.gz"
    sha256 "3bfa75b0ad0db84096ae777218481852c0ebc6c727b3168c1b9e0118e458cf0a"
  end

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/de/ef/3bae0e537cfe91e8431efcba4434463d2c5a65f5a89edd47c6cf2f03c55f/python_discovery-1.2.2.tar.gz"
    sha256 "876e9c57139eb757cb5878cbdd9ae5379e5d96266c99ef731119e04fffe533bb"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/4f/db/cfac1baf10650ab4d1c111714410d2fbb77ac5a616db26775db562c8fab2/setuptools-82.0.1.tar.gz"
    sha256 "7d872682c5d01cfde07da7bccc7b65469d3dca203318515ada1de5eda35efbf9"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/3f/8b/6331f7a7fe70131c301106ec1e7cf23e2501bf7d4ca3636805801ca191bb/virtualenv-21.3.0.tar.gz"
    sha256 "733750db978ec95c2d8eb4feadaa57091002bce404cb39ba69899cf7bd28944e"
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
