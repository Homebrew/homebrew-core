class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https://github.com/pypa/pipenv"
  url "https://files.pythonhosted.org/packages/d1/67/c29cb9081e5648b754b7ec95482e348b4d616681a3f0ee402ca082b9be02/pipenv-2024.0.1.tar.gz"
  sha256 "ae5a83fa5b66065cebd2bd8f73f0b281b3bd202a13d58cc644f0b9765128c990"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b4f3ff7ff9085381dd9b4e353b2fb9e2f5944c6d4286334773ebcf39949c8118"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4f3ff7ff9085381dd9b4e353b2fb9e2f5944c6d4286334773ebcf39949c8118"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4f3ff7ff9085381dd9b4e353b2fb9e2f5944c6d4286334773ebcf39949c8118"
    sha256 cellar: :any_skip_relocation, sonoma:         "90e8a8965b60fe69e4216861a103e18544b389c8b3842facf4cdb13b42399d1d"
    sha256 cellar: :any_skip_relocation, ventura:        "5c6dea987d8777301e6b896dbae7023b8a27f09504c884830aaaccf1ae806bd9"
    sha256 cellar: :any_skip_relocation, monterey:       "90e8a8965b60fe69e4216861a103e18544b389c8b3842facf4cdb13b42399d1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "113b677c94fcd894672153ca2de4b74ae3bc71253d8719d650b5061f96f919a4"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/c4/91/e2df406fb4efacdf46871c25cde65d3c6ee5e173b7e5a4547a47bae91920/distlib-0.3.8.tar.gz"
    sha256 "1530ea13e350031b6312d8580ddb6b27a104275a31106523b8f123787f494f64"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/06/ae/f8e03746f0b62018dcf1120f5ad0a1db99e55991f2cda0cf46edc8b897ea/filelock-3.14.0.tar.gz"
    sha256 "6ea72da3be9b8c82afd3edcf99f2fffbb5076335a5ae4d03248bb5b6c3eae78a"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/f5/52/0763d1d976d5c262df53ddda8d8d4719eedf9594d046f117c25a27261a19/platformdirs-4.2.2.tar.gz"
    sha256 "38b7b51f512eed9e84a22788b4bce1de17c0adb134d6becb09836e37d8654cd3"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/aa/60/5db2249526c9b453c5bb8b9f6965fcab0ddb7f40ad734420b3b421f7da44/setuptools-70.0.0.tar.gz"
    sha256 "f211a66637b8fa059bb28183da127d4e86396c991a942b028c6650d4319c3fd0"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/44/5a/cabd5846cb550e2871d9532def625d0771f4e38f765c30dc0d101be33697/virtualenv-20.26.2.tar.gz"
    sha256 "82bf0f4eebbb78d36ddaee0283d43fe5736b53880b8a8cdcd37390a07ac3741c"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(libexec/"bin/pipenv", shells:                 [:fish, :zsh],
                                                               shell_parameter_format: :click)
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
    assert_predicate testpath/"Pipfile", :exist?
    assert_predicate testpath/"Pipfile.lock", :exist?
    assert_match "requests", (testpath/"Pipfile").read
    assert_match "boto3", (testpath/"Pipfile").read
  end
end
