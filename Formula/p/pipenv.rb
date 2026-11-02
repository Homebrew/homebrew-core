class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https://github.com/pypa/pipenv"
  url "https://files.pythonhosted.org/packages/0d/f5/66f8e943bc78d30cff05f37d5836e8fefde33688ce118f5ca7291ebbb2db/pipenv-2026.10.5.tar.gz"
  sha256 "6228d3d0c4954bc5bdf28ace508073709110642993703e379a577277b4ecf1c5"
  license "MIT"
  head "https://github.com/pypa/pipenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9a7bc23908bade3e4a3849b0ba91b5a2cae154e6048392b1045b53ca0a46e061"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9a7bc23908bade3e4a3849b0ba91b5a2cae154e6048392b1045b53ca0a46e061"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9a7bc23908bade3e4a3849b0ba91b5a2cae154e6048392b1045b53ca0a46e061"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "42920ead429c6f7080c539d59d26798dc0c15806ec87152bee805f6f6e5bf8c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "42920ead429c6f7080c539d59d26798dc0c15806ec87152bee805f6f6e5bf8c3"
  end

  depends_on "certifi" => :no_linkage
  depends_on "python@3.15"

  pypi_packages package_name:     "pipenv[completion]",
                exclude_packages: "certifi"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/87/6f/5a73f04007ca950701765949209f068da628bd11f9c2da287278ce91e0ee/argcomplete-3.7.2.tar.gz"
    sha256 "aad8b69a0b9969edb62db0d1752354c0d50717b10e0cbb00e2a958381b9fc6b9"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/68/bc/d36966de7304047a1001a7559fbf266c464bb5d8cc85464536ef8c9bcc32/distlib-0.4.4.tar.gz"
    sha256 "ca4175b4ac7f71223cc30ed7248c45d2b38c2439d8ee6e498ab67ed63cf3508d"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/35/6c/730b340182f1fd74d4ef8d3f35431ce84f8f97b1a1f2afd145174b7bb047/filelock-4.2.6.tar.gz"
    sha256 "ee7af8ede36dcaf12e1016d9f7c3a63ecd5497d46f85dab21b8c779b8f944e97"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/9a/6e/886dc7c9d21e2d95aceb696f1e31271742033aeef3661f6e9c8921493592/platformdirs-4.14.3.tar.gz"
    sha256 "021add1ab113483edbcd4694f5fbb2d688b893ea30d35e1155bb371cf4be0be8"
  end

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/86/15/0405206e0cfe0c14b91ac038d31f30d1dd78139b3b2a285e6be41bf6e5af/python_discovery-1.9.0.tar.gz"
    sha256 "88beb57e51b919c30f303b053ec41359298ca349192035b0a802c76347ae96d7"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/70/b3/c19426f783614d625699a4b247faf628ea9ab1db228674491767b417f9e1/setuptools-84.2.1.tar.gz"
    sha256 "3ff8b3b5492a0aa66960f4419365a86b84e013070d4313e4d4a6894f5d64d6bc"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/38/9e/40c7098240cedd3a2f32e42a74b35c4563c617fdd7e41ae6268d4fdd8915/virtualenv-21.15.2.tar.gz"
    sha256 "dbd886e6e5689eb4dde6a9bbc478ad14b4fc8ed0852690d8273ccfb8c467f635"
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
    system bin/"pipenv", "--python", python3
    system bin/"pipenv", "install", "requests"
    system bin/"pipenv", "install", "boto3"
    assert_path_exists testpath/"Pipfile"
    assert_path_exists testpath/"Pipfile.lock"
    assert_match "requests", (testpath/"Pipfile").read
    assert_match "boto3", (testpath/"Pipfile").read
  end
end
