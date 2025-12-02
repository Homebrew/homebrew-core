class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https://github.com/pypa/pipenv"
  url "https://files.pythonhosted.org/packages/3b/15/4c869c2ec2819f8e6529cc26a044c9f7c714246c972b9b2cbbafda0847f9/pipenv-2025.0.4.tar.gz"
  sha256 "36fc2a7841ccdb2f58a9f787b296c2e15dea3b5b79b84d4071812f28b7e8d7a2"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07cffcfd928212629021bb5f0ee06f81afdb9b37cbec8dea985436b4715e2877"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07cffcfd928212629021bb5f0ee06f81afdb9b37cbec8dea985436b4715e2877"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07cffcfd928212629021bb5f0ee06f81afdb9b37cbec8dea985436b4715e2877"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e8db95cc1c6e320e5e6aef90b4ea31ecbb9708d5763244f2ec93e71917d4354"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e8db95cc1c6e320e5e6aef90b4ea31ecbb9708d5763244f2ec93e71917d4354"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e8db95cc1c6e320e5e6aef90b4ea31ecbb9708d5763244f2ec93e71917d4354"
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
    url "https://files.pythonhosted.org/packages/58/46/0028a82567109b5ef6e4d2a1f04a583fb513e6cf9527fcdd09afd817deeb/filelock-3.20.0.tar.gz"
    sha256 "711e943b4ec6be42e1d4e6690b48dc175c822967466bb31c0c293f34334c13f4"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/61/33/9611380c2bdb1225fdef633e2a9610622310fed35ab11dac9620972ee088/platformdirs-4.5.0.tar.gz"
    sha256 "70ddccdd7c99fc5942e9fc25636a8b34d04c24b335100223152c2803e4063312"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/a4/d5/b0ccd381d55c8f45d46f77df6ae59fbc23d19e901e2d523395598e5f4c93/virtualenv-20.35.3.tar.gz"
    sha256 "4f1a845d131133bdff10590489610c98c168ff99dc75d6c96853801f7f67af44"
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
