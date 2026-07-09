class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https://github.com/pypa/pipenv"
  url "https://files.pythonhosted.org/packages/26/4e/24ece5e63a4a81034453970e2289896f977999550abee4dcf81f1e0e963e/pipenv-2026.6.2.tar.gz"
  sha256 "fe513e97f3fc7027df22647aaf2b9de892f345f7e56dc0422e70b1213d641400"
  license "MIT"
  head "https://github.com/pypa/pipenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ca78611a181b36a1db52266137944a772c568130b9f62a527d349ad7827fdce8"
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
    url "https://files.pythonhosted.org/packages/86/b2/d6fc3f2347f43dada79e5ff118493e8109c98400a0e29a1d5264a3aa479b/distlib-0.4.1.tar.gz"
    sha256 "c3804d0d2d4b5fcd44036eb860cb6660485fcdf5c2aba53dc324d805837ea65b"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/1f/f9/f38573ed5844586db374d085911740a501ccfa373b455fc9413f09f85237/filelock-3.29.1.tar.gz"
    sha256 "d97e6b1b9757569626c58caa07dc4beb1613f4a2938b1e8cc81afca398906c9e"
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
    url "https://files.pythonhosted.org/packages/a6/12/38c1a0b1e64806780c9563e3fc9f6e472251839662587cfbe9bfaf2ae10a/python_discovery-1.4.0.tar.gz"
    sha256 "eb8bc7daad3c226c147e45bb4e970a1feb1bf4048ee178e6db59e197b8010ce3"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/4f/db/cfac1baf10650ab4d1c111714410d2fbb77ac5a616db26775db562c8fab2/setuptools-82.0.1.tar.gz"
    sha256 "7d872682c5d01cfde07da7bccc7b65469d3dca203318515ada1de5eda35efbf9"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/e1/0d/4e93c8e6d1001a75763f87d8f5ecda8ebc7f4aa2153dddfaf4ae8892821a/virtualenv-21.4.2.tar.gz"
    sha256 "38e6ee0a555615c0ea9da2ac7e9998fe8dc3b911dd33ad8eaad2020957653b0c"
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
