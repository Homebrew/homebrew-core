class PythonIdna < Formula
  desc "Internationalized Domain Names in Applications (IDNA)"
  homepage "https://github.com/kjd/idna"
  url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
  sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f90af9305ceef80cc8496fa0cac3e8826987609458c837422ea317ba2f8f4f63"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5a92a95f7b657c476f0d21d783f7f91756bf57485ef00e8bdf56e21315bcc52"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc4fb54e5e8d994cc019a987174e7e89e1f221cf48c0b2a0aa72724b5f460ba0"
    sha256 cellar: :any_skip_relocation, sonoma:         "f5b25bd4399569642fd192f26ec9c316cd46eb26812c07520282bc68c80f58d5"
    sha256 cellar: :any_skip_relocation, ventura:        "82e8ef90294d2b13cd77adc80af26bd2ccde80e5899d683208c2cc48d163e404"
    sha256 cellar: :any_skip_relocation, monterey:       "6e26a5d8b2fe7165ba4515f180e46416e38d62b3847ec38748d2437d1875862b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8efe129e5a958477ceddfe5f1a6fa039924b4811a7315f2052b39d99eb27dc8e"
  end

  deprecate! date: "2024-03-14", because: "does not meet homebrew/core's requirements for Python library formulae"

  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
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
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "import idna"
    end
  end
end
