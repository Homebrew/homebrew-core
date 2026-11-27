class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https://github.com/pypa/pipenv"
  url "https://files.pythonhosted.org/packages/c6/d5/7c50227a18d3129da089dc92f2c183f8b4ff1ea334a3e6a5caf92edfda1c/pipenv-2026.12.1.tar.gz"
  sha256 "7026d5bb6d5e06c9c61aa04957f80a311740b432c6efcfb6e71ddd778de66f17"
  license "MIT"
  head "https://github.com/pypa/pipenv.git", branch: "main"

  bottle do
    manifest_sha256 "c3b1ceae7e8409d983f1887b251ce434fd8ac89e78ab68f44a99f34f958423bf"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "08833bda5f4df09d03d47d584c7b6831afcf2af9f2b11551093c31110e8b9190"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "08833bda5f4df09d03d47d584c7b6831afcf2af9f2b11551093c31110e8b9190"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "08833bda5f4df09d03d47d584c7b6831afcf2af9f2b11551093c31110e8b9190"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "85d2c5fba33163e0fbbc92d7bc8eb30c9bd245e5ef8e05858deb8de678685917"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "85d2c5fba33163e0fbbc92d7bc8eb30c9bd245e5ef8e05858deb8de678685917"
  end

  depends_on "certifi" => :no_linkage
  depends_on "python@3.15"

  pypi_packages package_name:     "pipenv[completion]",
                exclude_packages: "certifi"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/19/0d/ca63f1b8b706c70590d0a4acc9c3c94ea8ed4dd9c83b4f7af195868abe76/argcomplete-3.8.0.tar.gz"
    sha256 "0114d634013e11ac92cc329b3a7d886c3506e98ddc7bb23c99b1782aacc8b8bd"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/68/bc/d36966de7304047a1001a7559fbf266c464bb5d8cc85464536ef8c9bcc32/distlib-0.4.4.tar.gz"
    sha256 "ca4175b4ac7f71223cc30ed7248c45d2b38c2439d8ee6e498ab67ed63cf3508d"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/e6/86/a5b9ec254b90efb180e390e31a4fa50a93b714d6e4174fa9a4ee25607159/filelock-4.3.1.tar.gz"
    sha256 "4c5ee627c401f1863ac6a0de9a14a28d3bb5f8c730b45e2fd6e5dbc79cf34b9e"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/c3/75/ffb1dc0ed12352139fb4ca0e3fde4325a23e3d0f3f40efe89717bc4f557b/packaging-26.4.tar.gz"
    sha256 "c4b671c41ddb9bf26e543c37723610d28fb6bf7affc4da17cf048d419d2c062a"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/71/18/0b0d99f5bf164f04a7a9534c3dbdbe4d5fd2b382667685ad40c192c4d3d1/platformdirs-4.14.8.tar.gz"
    sha256 "96893d686e84e9e6f358a9ea41a8de544df66dbf2ba6cda250e7dc73acf85b9b"
  end

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/0c/72/8e1d062fa1eed059b49a981394ab3ae26fffea6bbcffa4f7545aa2fb8c4f/python_discovery-1.9.7.tar.gz"
    sha256 "cea89e8a8b86e19731c67f8393f34eb1a2f96c9f97f3e406929a99c646a2358d"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/70/b3/c19426f783614d625699a4b247faf628ea9ab1db228674491767b417f9e1/setuptools-84.2.1.tar.gz"
    sha256 "3ff8b3b5492a0aa66960f4419365a86b84e013070d4313e4d4a6894f5d64d6bc"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/a1/89/e84f19b1a87f70637694494018fdedb395aed90da17872d31e1eb2314d41/virtualenv-21.15.13.tar.gz"
    sha256 "f3ad23551343034e613f9c4d8279f282958a19729f5fc2bcb758afcf95fe3a01"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(libexec/"bin/register-python-argcomplete", "pipenv", "--shell")
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    system bin/"pipenv", "--python", python3
    system bin/"pipenv", "install", "requests"
    system bin/"pipenv", "install", "boto3"
    assert_path_exists testpath/"Pipfile"
    assert_path_exists testpath/"Pipfile.lock"
    assert_match "requests", (testpath/"Pipfile").read
    assert_match "boto3", (testpath/"Pipfile").read
  end
end
