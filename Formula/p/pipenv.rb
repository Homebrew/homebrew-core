class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https://github.com/pypa/pipenv"
  url "https://files.pythonhosted.org/packages/6f/7f/389e0d3839c53a7ab5e99fe0dcd0dbd8c4ea269acf95861fb7cb2ca2ef1a/pipenv-2023.7.23.tar.gz"
  sha256 "77b1ba91d3cbfa85acb05fb447f5c8ab452dc377e0aea0f3ded8b2c36b669a45"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "183cbf7ad20f479dc1df113e30a77c78feda1e9753a98ba87dab1f51ffbfde8a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12a0f3fb752c97aa3820191e7242b236579727a2a49863a7b746876a61508924"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9038c479a691c8d60f39d49fc497913c08d26cf34ace1da108bf58d2f249cef3"
    sha256 cellar: :any_skip_relocation, ventura:        "7fc3a19011b99542024e275521c7ae52c732b4b1fd56b45ce0b079a939361709"
    sha256 cellar: :any_skip_relocation, monterey:       "3de68677f9a175e5dd66008c010a1cd4e09b0d5a684df0074d5fb7665c08a198"
    sha256 cellar: :any_skip_relocation, big_sur:        "1635d55e403f8e374e9df00319896f62d5cb5ae466a020d91a625be8ef59b72c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d118f584f911bb11d817e0e19a7eee5a2a18d925cc38fff67f2eeb7da15a3ffd"
  end

  depends_on "python-certifi"
  depends_on "python@3.11"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/29/34/63be59bdf57b3a8a8dcc252ef45c40f3c018777dc8843d45dd9b869868f0/distlib-0.3.7.tar.gz"
    sha256 "9dafe54b34a028eafd95039d5e5d4851a13734540f1331060d31c9916e7147a8"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/00/0b/c506e9e44e4c4b6c89fcecda23dc115bf8e7ff7eb127e0cb9c114cbc9a15/filelock-3.12.2.tar.gz"
    sha256 "002740518d8aa59a26b0c76e10fb8c6e15eae825d34b6fdf670333fd7b938d81"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/a1/70/c1d14c0c58d975f06a449a403fac69d3c9c6e8ae2a529f387d77c29c2e56/platformdirs-3.9.1.tar.gz"
    sha256 "1b42b450ad933e981d56e59f1b97495428c9bd60698baab9f3eb3d00d5822421"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/7c/08/cc69e4b3d499ee9570c4c57f23d5e71ed814fcf03988a4edd3081cb74577/virtualenv-20.24.1.tar.gz"
    sha256 "2ef6a237c31629da6442b0bcaa3999748108c7166318d1f55cc9f8d7294e97bd"
  end

  resource "virtualenv-clone" do
    url "https://files.pythonhosted.org/packages/85/76/49120db3bb8de4073ac199a08dc7f11255af8968e1e14038aee95043fafa/virtualenv-clone-0.5.7.tar.gz"
    sha256 "418ee935c36152f8f153c79824bb93eaf6f0f7984bae31d3f48f350b9183501a"
  end

  def python3
    "python3.11"
  end

  def install
    # Using the virtualenv DSL here because the alternative of using
    # write_env_script to set a PYTHONPATH breaks things.
    # https://github.com/Homebrew/homebrew-core/pull/19060#issuecomment-338397417
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources
    venv.pip_install buildpath

    # `pipenv` needs to be able to find `virtualenv` on PATH. So we
    # install symlinks for those scripts in `#{libexec}/tools` and create a
    # wrapper script for `pipenv` which adds `#{libexec}/tools` to PATH.
    (libexec/"tools").install_symlink libexec/"bin/pip", libexec/"bin/virtualenv"
    (bin/"pipenv").write_env_script libexec/"bin/pipenv", PATH: "#{libexec}/tools:${PATH}"

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
    system "#{bin}/pipenv", "--python", which(python3)
    system "#{bin}/pipenv", "install", "requests"
    system "#{bin}/pipenv", "install", "boto3"
    assert_predicate testpath/"Pipfile", :exist?
    assert_predicate testpath/"Pipfile.lock", :exist?
    assert_match "requests", (testpath/"Pipfile").read
    assert_match "boto3", (testpath/"Pipfile").read
  end
end
