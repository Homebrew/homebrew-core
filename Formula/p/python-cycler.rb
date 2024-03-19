class PythonCycler < Formula
  desc "Composable style cycles"
  homepage "https://github.com/matplotlib/cycler"
  url "https://files.pythonhosted.org/packages/a9/95/a3dbbb5028f35eafb79008e7522a75244477d2838f38cbb722248dabc2a8/cycler-0.12.1.tar.gz"
  sha256 "88bb128f02ba341da8ef447245a9e138fae777f6a23943da4540077d3601eb1c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "19c2f6fe7da98619d3a35a0e56e2bbf7acf67ac8bf095e7b1bf0ac891fcf5c45"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4bd8776f9fcd196712aea135621d5ea3991a19264437f2ef87a3a93a7878d84"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "decdf8fb5273919b75d63759248a7615061b7d81cf08fe566770aef1df86fcd1"
    sha256 cellar: :any_skip_relocation, sonoma:         "50354a9e72f92659c865369c2d87c3d74752ab10e4ba6a91ae2fb029aef6be9e"
    sha256 cellar: :any_skip_relocation, ventura:        "7d2a1a74b1c33d9bf007e17a6c50c3fbe22593161ab992e483a40d25a8f054d9"
    sha256 cellar: :any_skip_relocation, monterey:       "c66240feb2658eb8951324d95bc82bed1f8518c4280eadf816bc2508fdb180b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19fe582f20f78708f737e265963c4350748f9c38e99cae006249ea00be24784a"
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
      system python_exe, "-c", "import cycler"
    end
  end
end
