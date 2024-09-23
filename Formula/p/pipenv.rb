class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https://github.com/pypa/pipenv"
  url "https://files.pythonhosted.org/packages/cd/d6/61ee2953af7a5b79dfcd0649df8111825f2c1654d048c87c75261760f4bf/pipenv-2024.0.3.tar.gz"
  sha256 "0226ed63c81725117ed284bd58eb07e64207dc0c3fc8b52ead0ab2db91321870"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5dd341411831ba2908433422eebe45b3b93e9d2cd336d94985fc6eef41acd0f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5dd341411831ba2908433422eebe45b3b93e9d2cd336d94985fc6eef41acd0f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5dd341411831ba2908433422eebe45b3b93e9d2cd336d94985fc6eef41acd0f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "c50f524e9116adab3964c02b88a383e111bd841f96519af7f1b66215b6b4da0e"
    sha256 cellar: :any_skip_relocation, ventura:       "c50f524e9116adab3964c02b88a383e111bd841f96519af7f1b66215b6b4da0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44c00e78cc35da4abca3e17f27b53b801f4c6410600d0d22f70a465e2525fb05"
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
    url "https://files.pythonhosted.org/packages/9d/db/3ef5bb276dae18d6ec2124224403d1d67bccdbefc17af4cc8f553e341ab1/filelock-3.16.1.tar.gz"
    sha256 "c249fbfcd5db47e5e2d6d62198e565475ee65e4831e2561c8e313fa7eb961435"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/13/fc/128cc9cb8f03208bdbf93d3aa862e16d376844a14f9a0ce5cf4507372de4/platformdirs-4.3.6.tar.gz"
    sha256 "357fb2acbc885b0419afd3ce3ed34564c13c9b95c89360cd9563f73aa5e2b907"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/27/b8/f21073fde99492b33ca357876430822e4800cdf522011f18041351dfa74b/setuptools-75.1.0.tar.gz"
    sha256 "d59a21b17a275fb872a9c3dae73963160ae079f1049ed956880cd7c09b120538"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/bf/4c/66ce54c8736ff164e85117ca36b02a1e14c042a6963f85eeda82664fda4e/virtualenv-20.26.5.tar.gz"
    sha256 "ce489cac131aa58f4b25e321d6d186171f78e6cb13fafbf32a840cee67733ff4"
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
