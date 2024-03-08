class PythonArgcomplete < Formula
  desc "Tab completion for Python argparse"
  homepage "https://kislyuk.github.io/argcomplete/"
  url "https://files.pythonhosted.org/packages/3c/c0/031c507227ce3b715274c1cd1f3f9baf7a0f7cec075e22c7c8b5d4e468a9/argcomplete-3.2.3.tar.gz"
  sha256 "bf7900329262e481be5a15f56f19736b376df6f82ed27576fa893652c5de6c23"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2328c24c6ad6c34bc6cd1e8978ba9b56d614505a6f95b217c2e24ed961142def"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "60f23e1139b099d8ea2b446c304c3892878c982445ec53f6f39bbeef80a97f17"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f804aa13a4f8048326bf8125f29f06bdc683c71f8c616f126da5c0aad9f1bf8a"
    sha256 cellar: :any_skip_relocation, sonoma:         "95ab4f36f087bd784f876b64ac1c9f086964bd0551a4ff86e7405d50f02f08ab"
    sha256 cellar: :any_skip_relocation, ventura:        "c7d7dc6b7196c915863a60727077e84316c9fffd162d88e5a5de364e2c5e6977"
    sha256 cellar: :any_skip_relocation, monterey:       "d45b8b1429462e607a92f24076d0c1ea3e992ce1e11084db4aedcc5bdbefce1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23f5813e59516c0e40910ca03968b7aa7d908775231ee9539ca34cc857bae6d4"
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
