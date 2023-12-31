class PythonPyprojectHooks < Formula
  desc "Low-level library for calling build-backends in pyproject.toml-based project"
  homepage "https://pyproject-hooks.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/25/c1/374304b8407d3818f7025457b7366c8e07768377ce12edfe2aa58aa0f64c/pyproject_hooks-1.0.0.tar.gz"
  sha256 "f271b298b97f5955d53fb12b72c1fb1948c22c1a6b70b315c54cedaca0264ef5"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "61e5327de2af629625fed3f9d0b2340786d1a372b74d2b5803e080da3123f347"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "60239bff0688beb914501b874481c53ead651abac6b6629261271949e13ed5d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85a994d72e4d01ccde769b4a8da7d3a4735a02b65ff0101ea824f493a2dd6446"
    sha256 cellar: :any_skip_relocation, sonoma:         "067867c22a0c41616a106e5a9a0f53ee8a62d5578b7fa1ad8aaf75f34b99e0a0"
    sha256 cellar: :any_skip_relocation, ventura:        "9c7d01b37e60cde69d05e57489f7ebbd6694ac929a9e5d83eaebb06d8470a9d4"
    sha256 cellar: :any_skip_relocation, monterey:       "9ddf35918db3eb7b220acdc59679568ff1f92d6148dbfecaa864653c95926bd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d0a9fd09059057b4a13f99c1f300955fc8258068263391bda702119f1becb64"
  end

  depends_on "python-flit-core" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "import pyproject_hooks"
    end
  end
end
