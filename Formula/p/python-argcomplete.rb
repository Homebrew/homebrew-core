class PythonArgcomplete < Formula
  desc "Tab completion for Python argparse"
  homepage "https://kislyuk.github.io/argcomplete/"
  url "https://files.pythonhosted.org/packages/b8/a0/524e0aaabf9bc3dfcfb4da4c61a0469d5cbac31e39dd807a832ea6098c91/argcomplete-3.2.1.tar.gz"
  sha256 "437f67fb9b058da5a090df505ef9be0297c4883993f3f56cb186ff087778cfb4"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "13c4e0698c6f0fe24673c9920639f86a7334a7b08515c06bb49f065960780c70"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "20c8f272af0bc74adf10e543a5c7ae67835028f500acf1342778e6a21a33dd47"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4dff1e29bc72317f57fcaebc5636f16d218524c4e87e726d6bddab792e54ca68"
    sha256 cellar: :any_skip_relocation, sonoma:         "d1234d6f5e1ade4a526c21b72568f64e599b9764dfcf15b3caf95566cc501d18"
    sha256 cellar: :any_skip_relocation, ventura:        "0ca404bbb5bb564b136494a9d9c4c1c20af94237d95e72572fc0500026993f55"
    sha256 cellar: :any_skip_relocation, monterey:       "cc1b1d606505f4c2870530d460da6444d85c22201518f485d91dae00990db123"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82d477507c01c441680446607ca80954bfd0e007cf72b338caeb2accdff4db54"
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
