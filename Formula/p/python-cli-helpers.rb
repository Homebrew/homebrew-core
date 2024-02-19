class PythonCliHelpers < Formula
  desc "Python helpers for common CLI tasks"
  homepage "https://cli-helpers.readthedocs.io/en/stable/"
  url "https://files.pythonhosted.org/packages/ab/de/79529bd31c1664415d9554c0c5029f2137afe9808f35637bbcca977d9022/cli_helpers-2.3.1.tar.gz"
  sha256 "b82a8983ceee21f180e6fd0ddb7ca8dae43c40e920951e3817f996ab204dae6a"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2426d304b2ba1b128983d91a2efe5a8d16bfdb732f8e2cb20481b1beb53aaf5f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2996693762e2d2e7f1392dcf83153830c7d2e87582c5f57c1268f62bbb761c76"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a884f6cb5b1d6abdd5ae57698cf80016a98d33d54d0a76277b37bec577598b5f"
    sha256 cellar: :any_skip_relocation, sonoma:         "1272fa50b87f5641b43357d457a574addc3ff078dd49d93b6fc5b63baab7d091"
    sha256 cellar: :any_skip_relocation, ventura:        "c17b423dc21166b3cbe5de0c63f6a76fa7f29bb29b8206de08a36bfc974f7351"
    sha256 cellar: :any_skip_relocation, monterey:       "ad2e46937c5399cdda94d8d8edf80b44b621d9cf6edee60aaa7e61eaa21ff493"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5011a6c1d98b0c61d0db2751e23fa5ddcc7ba816b025af27b3d9b9466057418"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "python-configobj"
  depends_on "python-tabulate"
  depends_on "python-wcwidth"

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
      system python_exe, "-c", "from cli_helpers import tabular_output"
    end
  end
end
