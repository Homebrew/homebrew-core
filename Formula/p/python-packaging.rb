class PythonPackaging < Formula
  desc "Core utilities for Python packages"
  homepage "https://packaging.pypa.io/"
  url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
  sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  license any_of: ["Apache-2.0", "BSD-2-Clause"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4cf828add4d1558cf6dc594c3891afe1f23d45cc127c0be28afcc8845aaa8059"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4cf828add4d1558cf6dc594c3891afe1f23d45cc127c0be28afcc8845aaa8059"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4cf828add4d1558cf6dc594c3891afe1f23d45cc127c0be28afcc8845aaa8059"
    sha256 cellar: :any_skip_relocation, sonoma:         "4cf828add4d1558cf6dc594c3891afe1f23d45cc127c0be28afcc8845aaa8059"
    sha256 cellar: :any_skip_relocation, ventura:        "4cf828add4d1558cf6dc594c3891afe1f23d45cc127c0be28afcc8845aaa8059"
    sha256 cellar: :any_skip_relocation, monterey:       "4cf828add4d1558cf6dc594c3891afe1f23d45cc127c0be28afcc8845aaa8059"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00f80a3334512e058ba367fdb71e9dd40bf5edac49820fcd7ff734a40dc29ed2"
  end

  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python|
      system python, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
    end
  end

  def caveats
    <<~EOS
      Additional details on upcoming formula removal are available at:
      * https://github.com/Homebrew/homebrew-core/issues/157500
      * https://docs.brew.sh/Python-for-Formula-Authors#libraries
      * https://docs.brew.sh/Homebrew-and-Python#pep-668-python312-and-virtual-environments
    EOS
  end

  test do
    pythons.each do |python|
      system python, "-c", "import packaging"
    end
  end
end
