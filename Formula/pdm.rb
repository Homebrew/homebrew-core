class Pdm < Formula
  include Language::Python::Virtualenv

  desc "Modern Python package manager with PEP 582 support"
  homepage "https://pdm.fming.dev"
  url "https://files.pythonhosted.org/packages/74/4f/dcbbd585bb43a7210e97ee83b514c25060b4537022b082a3ce661def8bad/pdm-0.10.0.tar.gz"
  sha256 "34300685359501666eb28862e6cee4197d1ccff909edd34b6670136dbb4609da"
  license "MIT"
  head "https://github.com/frostming/pdm.git"

  depends_on "python@3.9"

  def python
    wanted = python_names.select { |py| needs_python?(py) }
    raise FormulaUnknownPythonError, self if wanted.empty?
    raise FormulaAmbiguousPythonError, self if wanted.size > 1

    result = wanted.first
    result = "python3" if result == "python"
    return result
  end

  def python_bin
    prefix = HOMEBREW_CELLAR/python
    version = Dir.entries(prefix).sort_by(&:downcase).last
    prefix/version/"bin/python3"
  end

  def install
    # Generate requirements from locked file
    system python_bin, "-m", "venv", libexec
    system libexec/"bin/pip", "install", "."

    Dir.mkdir "./completions"
    system "#{libexec}/bin/pdm completion bash > ./completions/pdm"
    system "#{libexec}/bin/pdm completion zsh > ./completions/_pdm"
    system "#{libexec}/bin/pdm completion fish > ./completions/pdm.fish"
    bash_completion.install "./completions/pdm"
    zsh_completion.install "./completions/_pdm"
    fish_completion.install "./completions/pdm.fish"

    bin.install_symlink(libexec/"bin/pdm")

  end

  test do
    system bin/"pdm" "--help"
  end
end
