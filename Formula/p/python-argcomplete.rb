class PythonArgcomplete < Formula
  desc "Tab completion for Python argparse"
  homepage "https://kislyuk.github.io/argcomplete/"
  url "https://files.pythonhosted.org/packages/75/33/a3d23a2e9ac78f9eaf1fce7490fee430d43ca7d42c65adabbb36a2b28ff6/argcomplete-3.5.0.tar.gz"
  sha256 "4349400469dccfb7950bb60334a680c58d88699bff6159df61251878dc6bf74b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a6bdf0c57cde56a841474d3c34e03ef1c7b654a507ae53a5ba6b1e8986d0149d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a6bdf0c57cde56a841474d3c34e03ef1c7b654a507ae53a5ba6b1e8986d0149d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6bdf0c57cde56a841474d3c34e03ef1c7b654a507ae53a5ba6b1e8986d0149d"
    sha256 cellar: :any_skip_relocation, sonoma:         "195df0a68e31aa3cc73b2785ab938582645a0dc45a2a8826105a2e6f5f9a1df2"
    sha256 cellar: :any_skip_relocation, ventura:        "195df0a68e31aa3cc73b2785ab938582645a0dc45a2a8826105a2e6f5f9a1df2"
    sha256 cellar: :any_skip_relocation, monterey:       "195df0a68e31aa3cc73b2785ab938582645a0dc45a2a8826105a2e6f5f9a1df2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c56f3360735c936dd2fbb39bd8dc3c71307b9d81a900a22a1f2603e14729e857"
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
