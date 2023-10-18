class PythonLxml < Formula
  desc "Pythonic binding for the libxml2 and libxslt libraries"
  homepage "https://github.com/lxml/lxml"
  url "https://files.pythonhosted.org/packages/30/39/7305428d1c4f28282a4f5bdbef24e0f905d351f34cf351ceb131f5cddf78/lxml-4.9.3.tar.gz"
  sha256 "48628bd53a426c9eb9bc066a923acaa0878d1e86129fd5359aee99285f4eed9c"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0053d3bb932417672f1208a39fe32cc004939eedf48d3b6260ba4ab7dd6e6a71"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "61817bea95e749a041fde129abfbfbf57e34f21965e0bcf75aec62915ef67d2f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "943fed91a4aa635aa6106d447b608faf7c8c193bdad0e787d6fc8eae225f5685"
    sha256 cellar: :any_skip_relocation, sonoma:         "9a393703230af1880064e2ad7d45cc854aaeca528cc13104ad157b6ec62f1a6c"
    sha256 cellar: :any_skip_relocation, ventura:        "0be496dfe111ff388228ce27bb456c27b2332fcbe41c8e018acebbe5de380b04"
    sha256 cellar: :any_skip_relocation, monterey:       "5a0cc74e848d0094ebf7d6d55ffe3b556441d754358b55b0be24527a12312b23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1656714ed0bb2b3c9c61807004fe6478651ef29ef909563b86ad29e60c4e77a7"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

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
      system python_exe, "-c", "import lxml"
    end
  end
end
