class PythonPyprojectHooks < Formula
  desc "Low-level library for calling build-backends in pyproject.toml-based project"
  homepage "https://pyproject-hooks.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/25/c1/374304b8407d3818f7025457b7366c8e07768377ce12edfe2aa58aa0f64c/pyproject_hooks-1.0.0.tar.gz"
  sha256 "f271b298b97f5955d53fb12b72c1fb1948c22c1a6b70b315c54cedaca0264ef5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "12be22531f5a27af50d7df689ccfdb0b148994375dfca5b35ddd6dbc005c307a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e472ee94bdf598870cb40fb7c17080ef06442eaada50f7d2ef6d539871366d96"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "81fba22aa0e064553dd9bb538c856b5e83b732272c3cfb2740a9df28c1d204d3"
    sha256 cellar: :any_skip_relocation, ventura:        "32ba199ffc8cbe501ffc241f8556d5f0becea7c433f2c2f16a5c2c8d6749ea7b"
    sha256 cellar: :any_skip_relocation, monterey:       "cc2707c722f79175e2c27d3f03f517d24acd1757b6c41b502f8d1d47d1256f2d"
    sha256 cellar: :any_skip_relocation, big_sur:        "bccf053b618ef9a883449cafb9b80984229d708a9f6b6f9d80aed436e7d2f2ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8921b8269afdf690ce3d5e42af0babeb36e8746c2deeeecfaa4ae3490bc74c0b"
  end

  depends_on "python-flit-core" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.9" => [:build, :test]

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
