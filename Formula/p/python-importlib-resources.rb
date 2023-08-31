class PythonImportlibResources < Formula
  desc "Read resources from Python packages"
  homepage "https://github.com/python/importlib_resources"
  url "https://files.pythonhosted.org/packages/fd/dc/0c5cfbd4df5d6e83de4e64324b370151ee88de25f3c71aea21115f4f77f8/importlib_resources-6.0.1.tar.gz"
  sha256 "4359457e42708462b9626a04657c6208ad799ceb41e5c58c57ffa0e6a098a5d4"
  license "Apache-2.0"

  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.9" => [:build, :test]
  depends_on "python-zipp"

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
      system python_exe, "-c", "import importlib_resources"
    end
  end
end
