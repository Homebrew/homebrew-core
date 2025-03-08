class PythonArgcomplete < Formula
  include Language::Python::Virtualenv

  desc "Tab completion for Python argparse"
  homepage "https://kislyuk.github.io/argcomplete/"
  url "https://files.pythonhosted.org/packages/ee/be/29abccb5d9f61a92886a2fba2ac22bf74326b5c4f55d36d0a56094630589/argcomplete-3.6.0.tar.gz"
  sha256 "2e4e42ec0ba2fff54b0d244d0b1623e86057673e57bafe72dda59c64bd5dee8b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f07fc88e9036cb1b5f5d1367b2d6e444a88205acccb0c04aef0191d9863c1cbf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f07fc88e9036cb1b5f5d1367b2d6e444a88205acccb0c04aef0191d9863c1cbf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f07fc88e9036cb1b5f5d1367b2d6e444a88205acccb0c04aef0191d9863c1cbf"
    sha256 cellar: :any_skip_relocation, sonoma:        "18bf1a1bc7c045fdd6daca3a143be3daf956f5c084c9681f6593a89b30f47165"
    sha256 cellar: :any_skip_relocation, ventura:       "18bf1a1bc7c045fdd6daca3a143be3daf956f5c084c9681f6593a89b30f47165"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9dc00776a43d63dceb2c600c5c6ffae949dec009a453d339e0f5ed1a294605d0"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources

    # Bash completions are not compatible with Bash 3 so don't use v1 directory.
    # Ref: https://kislyuk.github.io/argcomplete/#global-completion
    bash_completion_script = "argcomplete/bash_completion.d/_python-argcomplete"
    (share/"bash-completion/completions").install bash_completion_script => "python-argcomplete"
    zsh_completion.install_symlink bash_completion/"python-argcomplete" => "_python-argcomplete"
  end

  test do
    output = shell_output("#{bin}/register-python-argcomplete foo")
    assert_match "_python_argcomplete foo", output
  end
end
