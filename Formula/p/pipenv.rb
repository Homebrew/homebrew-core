class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https://github.com/pypa/pipenv"
  url "https://files.pythonhosted.org/packages/a6/26/5cdf9f0c6eb835074c3e43dde2880bfa739daa23fa534a5dd65848af5913/pipenv-2023.12.1.tar.gz"
  sha256 "4aea73e23944e464ad2b849328e780ad121c5336e1c24a7ac15aa493c41c2341"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d30d2b5eb4d230a6fb2accb076b53af6ee1a6816f92df41a74efc08b62aea13c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ce0cf201547b6982108929eca74cc82a074dcd88f94ab0fdd3f1078074fdffe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e56a0056fb62896bf6a35a05884b0732d16f90c63893e6bebaf507e0f03f1876"
    sha256 cellar: :any_skip_relocation, sonoma:         "a1fe87c478c5acf8e10932bcf83e0d04c74866acdbea642c94af06943836055d"
    sha256 cellar: :any_skip_relocation, ventura:        "97993ccf189c2c38417eccd1ca8008b24e0b58e3fa1a6a4ff0566b4adde62bf8"
    sha256 cellar: :any_skip_relocation, monterey:       "3e542eb02a44905c0127196dea12a7096f70584b0d3d760cbf04b30512906af6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5fd351c948333e6ba72b61c841166c96f3fb7faa411ecbf2e73dd9e9f2e44f1"
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
    url "https://files.pythonhosted.org/packages/70/70/41905c80dcfe71b22fb06827b8eae65781783d4a14194bce79d16a013263/filelock-3.13.1.tar.gz"
    sha256 "521f5f56c50f8426f5e03ad3b281b490a87ef15bc6c526f168290f0c7148d44e"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/96/dc/c1d911bf5bb0fdc58cc05010e9f3efe3b67970cef779ba7fbc3183b987a8/platformdirs-4.2.0.tar.gz"
    sha256 "ef0cc731df711022c174543cb70a9b5bd22e5a9337c8624ef2c2ceb8ddad8768"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/fc/c9/b146ca195403e0182a374e0ea4dbc69136bad3cd55bc293df496d625d0f7/setuptools-69.0.3.tar.gz"
    sha256 "be1af57fc409f93647f2e8e4573a142ed38724b8cdd389706a867bb4efcf1e78"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/94/d7/adb787076e65dc99ef057e0118e25becf80dd05233ef4c86f07aa35f6492/virtualenv-20.25.0.tar.gz"
    sha256 "bf51c0d9c7dd63ea8e44086fa1e4fb1093a31e963b86959257378aef020e1f1b"
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
    assert_match "Commands", shell_output("#{bin}/pipenv")
    system bin/"pipenv", "--python", which(python3)
    system bin/"pipenv", "install", "requests"
    system bin/"pipenv", "install", "boto3"
    assert_predicate testpath/"Pipfile", :exist?
    assert_predicate testpath/"Pipfile.lock", :exist?
    assert_match "requests", (testpath/"Pipfile").read
    assert_match "boto3", (testpath/"Pipfile").read
  end
end
