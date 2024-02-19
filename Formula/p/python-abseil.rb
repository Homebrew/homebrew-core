class PythonAbseil < Formula
  desc "Abseil Common Libraries (Python)"
  homepage "https://abseil.io/docs/python/"
  url "https://files.pythonhosted.org/packages/7a/8f/fc001b92ecc467cc32ab38398bd0bfb45df46e7523bf33c2ad22a505f06e/absl-py-2.1.0.tar.gz"
  sha256 "7820790efbb316739cde8b4e19357243fc3608a152024288513dd968d7d959ff"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "83f0387aa3171e7caeaddb08c6892f7fa8b9f0780ad07d60db33e2a6f57e9917"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ccfba0bf59d7038d86b938f8bbc91bc6a2a283005ee93683f8e16f810b33e861"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3909bdf32b6e4bbf4c452750daf471283e4f974edce93573fc9098f79b12e14"
    sha256 cellar: :any_skip_relocation, sonoma:         "597d641081fee06dcf18c2921e2e8433c9aee397ebd7d591fcc8c3c61e8326a3"
    sha256 cellar: :any_skip_relocation, ventura:        "93654037f21fa9d24071c30391ab44128773772ee97ae57c34f2585eb7f3b5b2"
    sha256 cellar: :any_skip_relocation, monterey:       "4461671b9d97fd6fab210a60c925d15823b150968411668a98d72990cb1b36ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e299c2964319df05c0c3999c279528d6bd9b716df5886e70ff9dc0cc10f5accf"
  end

  depends_on "python-setuptools" => :build
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
      system python_exe, "-c", "from absl import app"
    end
  end
end
