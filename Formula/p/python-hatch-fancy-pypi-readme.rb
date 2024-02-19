class PythonHatchFancyPypiReadme < Formula
  desc "Fancy PyPI READMEs with Hatch"
  homepage "https://github.com/hynek/hatch-fancy-pypi-readme"
  url "https://files.pythonhosted.org/packages/b4/c2/c9094283a07dd96c5a8f7a5f1910259d40d2e29223b95dd875a6ca13b58f/hatch_fancy_pypi_readme-24.1.0.tar.gz"
  sha256 "44dd239f1a779b9dcf8ebc9401a611fd7f7e3e14578dcf22c265dfaf7c1514b8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d4c3f8185b32c449ab58bc66a08e66b58d913e6fe79ae7d4e3b3d48ec32005c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "01526f96c3e043b95ac19bf50d61aa5ab38b1619acfc05428396884a5ec11383"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a06e94727f51fd156426583099178de403851efcddb09f77995e4eb4b3a6bd9f"
    sha256 cellar: :any_skip_relocation, sonoma:         "ccea27f170f363bb34c4b7dd40b785c9b4fd8becc4855c7d15eeaab50f061014"
    sha256 cellar: :any_skip_relocation, ventura:        "78cfa7cc2639eda4debe0dd9c21d2558e1430b6a444dedab70b2f6374ec0c35e"
    sha256 cellar: :any_skip_relocation, monterey:       "88df9e35bf6f15e9324a834a363593b59b036cbb41728a64d652352dc82f87f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17b65cebd66a27b258c64ab0778f95c33bd137c55b078ab868e412389e116f58"
  end

  depends_on "python-hatchling" => [:build, :test]
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

  def caveats
    <<~EOS
      To run `hatch-fancy-pypi-readme`, you may need to `brew install #{pythons.last}`
    EOS
  end

  test do
    (testpath/"pyproject.toml").write <<~END
      [build-system]
      requires = ["hatchling", "hatch-fancy-pypi-readme"]
      build-backend = "hatchling.build"

      [project]
      dynamic = ["readme"]

      [tool.hatch.metadata.hooks.fancy-pypi-readme]
      content-type = "text/markdown"

      [[tool.hatch.metadata.hooks.fancy-pypi-readme.fragments]]
      text = "Fragment #1"

      [[tool.hatch.metadata.hooks.fancy-pypi-readme.fragments]]
      text = "Fragment #2"
    END

    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "import hatch_fancy_pypi_readme"

      output = shell_output("#{bin}/hatch-fancy-pypi-readme --hatch-toml pyproject.toml")
      assert_match "Fragment #1Fragment #2", output
    end
  end
end
