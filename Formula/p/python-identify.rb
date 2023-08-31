class PythonIdentify < Formula
  desc "File identification library for Python"
  homepage "https://github.com/pre-commit/identify"
  url "https://files.pythonhosted.org/packages/e0/7e/dc9ae38e2944611174051371e62cb79a9fd98fd8b4e4f07d0c1fbf2bb260/identify-2.5.27.tar.gz"
  sha256 "287b75b04a0e22d727bc9a41f0d4f3c1bcada97490fa6eabb5b28f0e9097e733"
  license "MIT"

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
      system python_exe, "-c", "import identify"

      output = shell_output("#{bin}/identify-cli testpath 2>&1", 1)
      assert_match "testpath does not exist.", output
    end
  end
end
