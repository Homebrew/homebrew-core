class PythonArgcomplete < Formula
  desc "Tab completion for Python argparse"
  homepage "https://kislyuk.github.io/argcomplete/"
  url "https://files.pythonhosted.org/packages/3c/c0/031c507227ce3b715274c1cd1f3f9baf7a0f7cec075e22c7c8b5d4e468a9/argcomplete-3.2.3.tar.gz"
  sha256 "bf7900329262e481be5a15f56f19736b376df6f82ed27576fa893652c5de6c23"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cac00ccede9d57ed46f041837e8285d06879fdb728ef77264c1f9e226d0f6841"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cac00ccede9d57ed46f041837e8285d06879fdb728ef77264c1f9e226d0f6841"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cac00ccede9d57ed46f041837e8285d06879fdb728ef77264c1f9e226d0f6841"
    sha256 cellar: :any_skip_relocation, sonoma:         "4b28834c0cd22f5a0b2ef0579131c50d575dfa5b439300b757901f74305c687d"
    sha256 cellar: :any_skip_relocation, ventura:        "4b28834c0cd22f5a0b2ef0579131c50d575dfa5b439300b757901f74305c687d"
    sha256 cellar: :any_skip_relocation, monterey:       "4b28834c0cd22f5a0b2ef0579131c50d575dfa5b439300b757901f74305c687d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09d6d2676b7d1d6eba28ce17ce0fa3bd48d0c2c01d9d5d1b4181b09fd02ddca9"
  end

  depends_on "python-setuptools" => :build
  depends_on "python-setuptools-scm" => :build
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
