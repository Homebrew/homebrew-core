class Cython < Formula
  include Language::Python::Virtualenv

  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/99/ca/18e324972e5cac914816fdd7bb03e19a455b90039c277a538f7781b50c85/cython-3.3.1.tar.gz"
  sha256 "e0e45989e821bef6aa9ae15c7d583ab5e055f7406c4b3624e49e06d24e90375a"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/cython/cython.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "66f85e2a3c54639d600c5f09c388bb56faeaf83d742df30166075d8a7cca285d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "deea525b5975cf16e6fc8a3f21fdf4e03411686ea6ebef037ae57c5bc28e1336"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6bd1c91f24ac61ce04fd5114a59ab606ee62dd97c813fb85037ee0d9956478d7"
    sha256 cellar: :any,                 arm64_linux:       "34e1c32b3315d379d68f07c608a2b2eb067d228d50a1f5b9f5edbbd638dc3176"
    sha256 cellar: :any,                 x86_64_linux:      "dd564be2ef4792ec5c325228b40277a417f1098954144146ce69be5a1fe1ea53"
  end

  depends_on "python@3.15"

  # https://github.com/cython/cython/issues/5976
  pypi_packages extra_packages: "setuptools"

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/70/b3/c19426f783614d625699a4b247faf628ea9ab1db228674491767b417f9e1/setuptools-84.2.1.tar.gz"
    sha256 "3ff8b3b5492a0aa66960f4419365a86b84e013070d4313e4d4a6894f5d64d6bc"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    phrase = "You are using Homebrew"
    (testpath/"example.pyx").write "print '#{phrase}'"

    system bin/"cythonize", "--inplace", "example.pyx"
    assert_match phrase, shell_output("#{libexec}/bin/python -c 'import example'")
  end
end
