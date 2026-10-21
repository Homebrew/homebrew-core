class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https://github.com/pypa/pipenv"
  url "https://files.pythonhosted.org/packages/c5/94/2b63fd4a13159e87d27ce1d390d82bc17431176358ef638989447cea76c5/pipenv-2026.10.1.tar.gz"
  sha256 "8dc8aebe5c8bf59abfbf7e91bfe964637eb0863f29991ebe74cce61b1326dbfe"
  license "MIT"
  head "https://github.com/pypa/pipenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a73aea2d72776cce5858d248924ef94fe776d10213bb99e99534b4c6b5fdb9c3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a73aea2d72776cce5858d248924ef94fe776d10213bb99e99534b4c6b5fdb9c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a73aea2d72776cce5858d248924ef94fe776d10213bb99e99534b4c6b5fdb9c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3dd7ef5ea9f327292d9df63bee3408575d55ccb2244119159b94d3c3d0f04883"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "3dd7ef5ea9f327292d9df63bee3408575d55ccb2244119159b94d3c3d0f04883"
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
    url "https://files.pythonhosted.org/packages/d4/08/d8f81287742010e38daf3632380c8d80ede7b4df2716f8ca3d0a2b087d44/filelock-4.2.2.tar.gz"
    sha256 "b29ff2ae9140bb17b3bc77c648dc4f010d9ac0955eccabff4f2b01dde859f787"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/b7/89/dfd269de936e76319cf27787d9eaaca513491f635d49b0fbe7cdb6d3bf6f/platformdirs-4.13.4.tar.gz"
    sha256 "dd96496961684a7f42041923f842ec7494e09f5e87aded99117e1109cd40570e"
  end

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/fc/54/fad125f5c48f7821644ee6f223ebfcedc4e23597c1a16eeb13d33aa4a91a/python_discovery-1.6.3.tar.gz"
    sha256 "a62b301d96cf5489cb96ab023b32e068421867fdd5df2e42eece877869047fa2"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/6d/44/f5da03a8ef95d369145c5bb53050e7877c9f3d312e128605fd9504829143/setuptools-84.0.0.tar.gz"
    sha256 "f4695c21257f0d9b537ec2692c941d02ee143b7cc1276941349a546573b2ef73"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/7f/be/4d1d59d309db76b5808fcfd78bd5996f4e7241366691c38fc331a3136398/virtualenv-21.14.11.tar.gz"
    sha256 "593052d8477ea8c55a842387ce111bd08c72618f0c1133c302cafe335e570a57"
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
