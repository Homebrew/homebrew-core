class PythonArgcomplete < Formula
  desc "Tab completion for Python argparse"
  homepage "https://kislyuk.github.io/argcomplete/"
  url "https://files.pythonhosted.org/packages/5f/39/27605e133e7f4bb0c8e48c9a6b87101515e3446003e0442761f6a02ac35e/argcomplete-3.5.1.tar.gz"
  sha256 "eb1ee355aa2557bd3d0145de7b06b2a45b0ce461e1e7813f5d066039ab4177b4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba92a9b10c5c664e217cceed4ea4620531f4d0968af95609371fd7817187787a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba92a9b10c5c664e217cceed4ea4620531f4d0968af95609371fd7817187787a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ba92a9b10c5c664e217cceed4ea4620531f4d0968af95609371fd7817187787a"
    sha256 cellar: :any_skip_relocation, sonoma:        "df4493850b5c6e08be232c7cc861e5fe6be94310843f2f0c12e969e5a9e5fddb"
    sha256 cellar: :any_skip_relocation, ventura:       "df4493850b5c6e08be232c7cc861e5fe6be94310843f2f0c12e969e5a9e5fddb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4aa09c2b9e5fa6919c6145a7f1e05ae4d8199087e2def1a5d19dfc4d3b44b636"
  end

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

    # Bash completions are not compatible with Bash 3 so don't use v1 directory.
    # Ref: https://kislyuk.github.io/argcomplete/#global-completion
    bash_completion_script = "argcomplete/bash_completion.d/_python-argcomplete"
    (share/"bash-completion/completions").install bash_completion_script => "python-argcomplete"
    zsh_completion.install_symlink bash_completion/"python-argcomplete" => "_python-argcomplete"
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "import argcomplete"
    end

    output = shell_output("#{bin}/register-python-argcomplete foo")
    assert_match "_python_argcomplete foo", output
  end
end
