class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https://github.com/pypa/pipenv"
  url "https://files.pythonhosted.org/packages/90/03/8958464e0d366530477f07fd041ef6b9df56f3ea9c56d0db24cc8cd87fff/pipenv-2026.0.3.tar.gz"
  sha256 "9a39d13a41ed8e4368ad50620941191f357319c8ffb7df45875c7c5dc6604ff6"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1aeb39ef3c0cd99827b7a21e50c543fb0b53377a03ec07d365fefb9963c8f4bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1aeb39ef3c0cd99827b7a21e50c543fb0b53377a03ec07d365fefb9963c8f4bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1aeb39ef3c0cd99827b7a21e50c543fb0b53377a03ec07d365fefb9963c8f4bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed16d7788ae768bf378b03deb95a4ff9b0d7398f35ca36153f194845042bfd5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed16d7788ae768bf378b03deb95a4ff9b0d7398f35ca36153f194845042bfd5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed16d7788ae768bf378b03deb95a4ff9b0d7398f35ca36153f194845042bfd5d"
  end

  depends_on "certifi" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  def python3
    "python3.14"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/96/8e/709914eb2b5749865801041647dc7f4e6d00b549cfe88b65ca192995f07c/distlib-0.4.0.tar.gz"
    sha256 "feec40075be03a04501a973d81f633735b4b69f98b05450592310c0f401a4e0d"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/1d/65/ce7f1b70157833bf3cb851b556a37d4547ceafc158aa9b34b36782f23696/filelock-3.20.3.tar.gz"
    sha256 "18c57ee915c7ec61cff0ecf7f0f869936c7c30191bb0cf406f1341778d0834e1"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/cf/86/0248f086a84f01b37aaec0fa567b397df1a119f73c16f6c7a9aac73ea309/platformdirs-4.5.1.tar.gz"
    sha256 "61d5cdcc6065745cdd94f0f878977f8de9437be93de97c1c12f853c9c0cdcbda"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/aa/a3/4d310fa5f00863544e1d0f4de93bddec248499ccf97d4791bc3122c9d4f3/virtualenv-20.36.1.tar.gz"
    sha256 "8befb5c81842c641f8ee658481e42641c68b5eab3521d8e092d18320902466ba"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(libexec/"bin/pipenv", shell_parameter_format: :click)
  end

  # Avoid relative paths
  def post_install
    lib_python_path = Pathname.glob(libexec/"lib/python*").first
    lib_python_path.each_child do |f|
      next unless f.symlink?

      realpath = f.realpath
      rm f
      ln_s realpath, f
    end
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    assert_match "Commands", shell_output(bin/"pipenv")
    system bin/"pipenv", "--python", which(python3)
    system bin/"pipenv", "install", "requests"
    system bin/"pipenv", "install", "boto3"
    assert_path_exists testpath/"Pipfile"
    assert_path_exists testpath/"Pipfile.lock"
    assert_match "requests", (testpath/"Pipfile").read
    assert_match "boto3", (testpath/"Pipfile").read
  end
end
